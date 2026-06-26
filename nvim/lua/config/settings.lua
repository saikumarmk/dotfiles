-- ===================================================================
-- Basic Neovim Settings
-- ===================================================================

local opt = vim.opt
local g = vim.g

-- Compatibility shim for plugins that still call deprecated vim.tbl_flatten
-- on Neovim 0.12+. Keep behavior equivalent without emitting startup warnings.
if vim.iter then
  vim.tbl_flatten = function(t)
    return vim.iter(t):flatten(math.huge):totable()
  end
end

-- General
opt.mouse = "a"                     -- Enable mouse support
opt.swapfile = false                -- No swap files
opt.completeopt = "menu,menuone,noselect"

-- UI
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.cursorline = true               -- Highlight current line
opt.termguicolors = true            -- True color support
opt.signcolumn = "yes"              -- Always show sign column
opt.scrolloff = 8                   -- Keep 8 lines visible when scrolling
opt.sidescrolloff = 8               -- Keep 8 columns visible when scrolling
opt.wrap = true                     -- Wrap long lines
opt.linebreak = true                -- Break lines at word boundaries
opt.showmode = false                -- Don't show mode (status line does this)

-- Indentation
opt.expandtab = true                -- Use spaces instead of tabs
opt.tabstop = 4                     -- 4 spaces for tab
opt.shiftwidth = 4                  -- 4 spaces for indentation
opt.softtabstop = 4                 -- 4 spaces for soft tab
opt.smartindent = true              -- Smart indentation
opt.autoindent = true               -- Auto indentation

-- Search
opt.ignorecase = true               -- Case insensitive search
opt.smartcase = true                -- Case sensitive if uppercase present
opt.hlsearch = true                 -- Highlight search results
opt.incsearch = true                -- Incremental search

-- Splits
opt.splitbelow = true               -- Split below by default
opt.splitright = true               -- Split right by default

-- Performance
opt.updatetime = 250                -- Faster completion
opt.timeoutlen = 300                -- Faster key sequence completion

-- Python provider: dedicated uv venv so pynvim/jupyter_client stay isolated
-- from system Python (3.14 has no wheels for many nvim plugins yet).
-- Create with: uv venv ~/.venv/nvim --python 3.12
-- Install with: uv pip install --python ~/.venv/nvim/bin/python pynvim jupyter_client cairosvg pyperclip ipykernel
local nvim_venv = vim.fn.expand("~/.venv/nvim/bin/python")
if vim.fn.executable(nvim_venv) == 1 then
  g.python3_host_prog = nvim_venv
else
  g.python3_host_prog = vim.fn.exepath("python3")
end

-- OCaml indentation from the CS3110 opam switch, if available.
local ocp_indent_rtp = vim.fn.expand("~/.opam/cs3110-2026sp/share/ocp-indent/vim")
if vim.fn.isdirectory(ocp_indent_rtp) == 1 then
  opt.runtimepath:prepend(ocp_indent_rtp)
end

-- Clipboard provider detection with Linux-friendly fallback:
-- - Prefer native providers (wl-clipboard/xclip/xsel)
-- - Fall back to OSC52 when available (useful in terminals/SSH/tmux)
-- - Otherwise keep default registers to avoid clipboard health errors
local has_wl_clipboard = vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1
local has_xclip = vim.fn.executable("xclip") == 1
local has_xsel = vim.fn.executable("xsel") == 1

if has_wl_clipboard or has_xclip or has_xsel then
  opt.clipboard = "unnamedplus"
elseif vim.fn.has("nvim-0.10") == 1 then
  g.clipboard = "osc52"
  opt.clipboard = "unnamedplus"
else
  opt.clipboard = ""
end

-- OCaml ecosystem filetypes that Neovim may not infer in every setup.
vim.filetype.add({
  extension = {
    mll = "ocamllex",
    mly = "menhir",
    re = "reason",
    rei = "reason",
  },
  filename = {
    dune = "dune",
    ["dune-project"] = "dune",
    ["dune-workspace"] = "dune",
  },
  pattern = {
    [".*/dune"] = "dune",
  },
})

-- Disable some built-in plugins
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
