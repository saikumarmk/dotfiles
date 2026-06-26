-- ===================================================================
-- DAP launch configs: VS Code launch.json-style templates + per-project
-- ===================================================================
--
-- Per-project overrides: <project>/.nvim/dap.lua
--
--   return {
--     {
--       name = "ass1: TinyStories",
--       program = "${workspaceFolder}/ass1.py",
--       cwd = "${workspaceFolder}",
--       args = { "data/foo.txt", "500" },
--     },
--   }
--
-- Placeholders: ${file}, ${fileDirname}, ${fileBasename},
--               ${fileBasenameNoExtension}, ${workspaceFolder}
-- ===================================================================

local M = {}

local ROOT_MARKERS = { ".git", "pyproject.toml", "package.json", ".nvim" }

local function find_workspace_root(start_dir)
  local dir = start_dir or vim.fn.getcwd()
  while dir and dir ~= "/" do
    for _, marker in ipairs(ROOT_MARKERS) do
      local path = dir .. "/" .. marker
      if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
        return dir
      end
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return vim.fn.getcwd()
end

function M.resolve_python()
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    local venv_python = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  local dir = find_workspace_root()
  while dir and dir ~= "/" do
    local project_python = dir .. "/.venv/bin/python"
    if vim.fn.executable(project_python) == 1 then
      return project_python
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  return vim.fn.exepath("python3")
end

function M.context()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    file = vim.fn.getcwd() .. "/__main__.py"
  end
  local root = find_workspace_root(vim.fn.fnamemodify(file, ":h"))
  return {
    file = file,
    fileDirname = vim.fn.fnamemodify(file, ":h"),
    fileBasename = vim.fn.fnamemodify(file, ":t"),
    fileBasenameNoExtension = vim.fn.fnamemodify(file, ":t:r"),
    workspaceFolder = root,
  }
end

local function expand_value(value, ctx)
  if type(value) == "string" then
    return (value:gsub("%${([^}]+)}", function(key)
      return ctx[key] or ("${" .. key .. "}")
    end))
  end
  if type(value) == "table" then
    if vim.islist(value) then
      local out = {}
      for i, v in ipairs(value) do
        out[i] = expand_value(v, ctx)
      end
      return out
    end
    local out = {}
    for k, v in pairs(value) do
      out[k] = expand_value(v, ctx)
    end
    return out
  end
  return value
end

function M.expand_config(config)
  return expand_value(vim.deepcopy(config), M.context())
end

function M.prompt_args()
  local input = vim.fn.input("Debug arguments: ")
  if input == "" then
    return {}
  end
  local ok, split = pcall(require, "dap.utils")
  if ok and split.splitstr and vim.fn.has("nvim-0.10") == 1 then
    return split.splitstr(input)
  end
  return vim.split(input, "%s+", { trimempty = true })
end

local function normalize_entry(entry)
  local config = vim.deepcopy(entry)
  config.type = config.type or "python"
  config.request = config.request or "launch"
  config.console = config.console or "integratedTerminal"
  if config.justMyCode == nil then
    config.justMyCode = false -- step into library code (pytest, torch, etc.)
  end
  if not config.name then
    config.name = config.program or config.module or "unnamed"
  end
  return config
end

function M.default_templates()
  return {
    {
      name = "Python: Current File",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      name = "Python: Current File (args)",
      program = "${file}",
      cwd = "${workspaceFolder}",
      args = function()
        return M.prompt_args()
      end,
    },
    {
      name = "Python: Current File (module)",
      module = "${fileBasenameNoExtension}",
      cwd = "${fileDirname}",
    },
  }
end

local function lua_string(value)
  if type(value) == "string" then
    return string.format("%q", value)
  end
  if type(value) == "table" and vim.islist(value) then
    if #value == 0 then
      return "{}"
    end
    local parts = {}
    for _, v in ipairs(value) do
      table.insert(parts, string.format("%q", v))
    end
    -- Single-line list avoids writefile/multiline corruption
    return "{ " .. table.concat(parts, ", ") .. " }"
  end
  if value == nil then
    return "nil"
  end
  return tostring(value)
end

local function read_project_configs(path)
  local loader, err = loadfile(path)
  if not loader then
    return nil, err
  end
  local ok, configs = pcall(loader)
  if not ok then
    return nil, configs
  end
  if type(configs) ~= "table" then
    return nil, "must return a list of launch configs"
  end
  return configs
end

function M.load_project_configs()
  local root = find_workspace_root()
  local path = root .. "/.nvim/dap.lua"
  if vim.fn.filereadable(path) ~= 1 then
    return {}
  end

  local configs, err = read_project_configs(path)
  if not configs then
    vim.notify("Failed to load " .. path .. ": " .. tostring(err), vim.log.levels.ERROR)
    return {}
  end
  return configs
end

function M.all_configs()
  local configs = {}
  for _, entry in ipairs(M.default_templates()) do
    table.insert(configs, normalize_entry(entry))
  end
  for _, entry in ipairs(M.load_project_configs()) do
    table.insert(configs, normalize_entry(entry))
  end
  return configs
end

function M.refresh()
  local python = M.resolve_python()
  require("dap-python").setup(python, { include_configs = false })
  require("dap-python").test_runner = "pytest"
  require("dap").configurations.python = M.all_configs()
  return python
end

function M.setup()
  M.refresh()
end

function M.run(config)
  local expanded = M.expand_config(config)
  if type(expanded.args) == "function" then
    expanded.args = expanded.args()
  end
  require("dap").run(expanded)
end

function M.pick_config()
  local configs = M.all_configs()
  if #configs == 0 then
    vim.notify("No DAP launch configs found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(configs, {
    prompt = "Debug launch config",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      M.run(choice)
    end
  end)
end

function M.run_current_file_with_args()
  for _, config in ipairs(M.all_configs()) do
    if config.name == "Python: Current File (args)" then
      M.run(config)
      return
    end
  end
end

function M.template_new()
  local ctx = M.context()
  local name = vim.fn.input("Config name: ")
  if name == "" then
    return
  end

  local use_current = vim.fn.input("Program [current file]: ")
  local program
  if use_current == "" then
    program = "${file}"
  elseif use_current:match("^%${") then
    program = use_current
  else
    program = use_current:match("^/") and use_current or ("${workspaceFolder}/" .. use_current)
  end

  local args_input = vim.fn.input("Args (space-separated, optional): ")
  local args = {}
  if args_input ~= "" then
    args = vim.split(args_input, "%s+", { trimempty = true })
  end

  local cwd = vim.fn.input("cwd [" .. ctx.workspaceFolder .. "]: ")
  if cwd == "" then
    cwd = "${workspaceFolder}"
  end

  local entry = normalize_entry({
    name = name,
    program = program,
    cwd = cwd,
    args = args,
  })

  local action = vim.fn.input("Action ([r]un / [s]ave to .nvim/dap.lua / [b]oth): ")
  if action == "s" or action == "b" then
    M.save_project_config(entry)
  end
  if action == "r" or action == "" or action == "b" then
    M.run(entry)
  end
end

function M.save_project_config(entry)
  local root = find_workspace_root()
  local dir = root .. "/.nvim"
  local path = dir .. "/dap.lua"

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local configs, load_err = read_project_configs(path)
  if not configs then
    if vim.fn.filereadable(path) == 1 then
      vim.notify(
        "Replacing invalid .nvim/dap.lua: " .. tostring(load_err),
        vim.log.levels.WARN
      )
    end
    configs = {}
  end

  table.insert(configs, {
    name = entry.name,
    program = entry.module and nil or entry.program,
    module = entry.module,
    cwd = entry.cwd,
    args = entry.args or {},
  })

  local lines = { "return {" }
  for _, cfg in ipairs(configs) do
    table.insert(lines, "  {")
    table.insert(lines, "    name = " .. lua_string(cfg.name) .. ",")
    if cfg.module then
      table.insert(lines, "    module = " .. lua_string(cfg.module) .. ",")
    elseif cfg.program then
      table.insert(lines, "    program = " .. lua_string(cfg.program) .. ",")
    end
    table.insert(lines, "    cwd = " .. lua_string(cfg.cwd) .. ",")
    table.insert(lines, "    args = " .. lua_string(cfg.args) .. ",")
    table.insert(lines, "  },")
  end
  table.insert(lines, "}")

  vim.fn.writefile(lines, path)
  M.refresh()
  vim.notify("Saved launch config to " .. path, vim.log.levels.INFO)
end

return M
