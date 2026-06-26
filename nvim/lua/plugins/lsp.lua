-- ===================================================================
-- LSP Configuration with Mason (Neovim 0.11+ Compatible)
-- ===================================================================
--
-- Uses the NEW vim.lsp.config API (replaces deprecated lspconfig.setup())
-- See :help lspconfig-nvim-0.11 for details
--
-- Language Servers:
-- - basedpyright: Python (replaces deprecated pyright)
-- - lua_ls: Lua
-- - marksman: Markdown
-- - jsonls: JSON
-- - yamlls: YAML
-- - bashls: Bash
-- - ts_ls: TypeScript / JavaScript
-- - svelte: Svelte
-- - html: HTML
-- - cssls: CSS
-- - tailwindcss: Tailwind CSS
-- - eslint: JS/TS linting diagnostics
-- - ocamllsp: OCaml / Reason / Dune
-- - r_language_server: R (optional, manual install required)
--
-- To install R language server:
--   1. Install R: brew install r
--   2. In R console: install.packages("languageserver")
--   3. In Neovim: :Mason -> search "r-language-server" -> press "i"
--
-- ===================================================================

return {
  -- Mason: Package manager for LSP servers, DAP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Mason-LSPConfig: Bridges mason.nvim with nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "basedpyright",   -- Python (modern alternative to pyright)
          "lua_ls",         -- Lua
          "marksman",       -- Markdown
          "jsonls",         -- JSON
          "yamlls",         -- YAML
          "bashls",         -- Bash
          "ts_ls",          -- TypeScript / JavaScript
          "svelte",         -- Svelte
          "html",           -- HTML
          "cssls",          -- CSS
          "tailwindcss",    -- Tailwind CSS
          "eslint",         -- JS/TS linting diagnostics
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSPConfig: Using new vim.lsp.config API (Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Global LSP keymaps (applied via autocmd)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          -- Formatting is handled by conform.nvim (<leader>lf)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        end,
      })

      -- Configure LSP servers using new vim.lsp.config API
      local lspconfig = require("lspconfig")

      -- Python (BasedPyright)
      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 1000,
        },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      }

      -- Lua
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- Markdown
      vim.lsp.config.marksman = {
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        root_markers = { ".marksman.toml", ".git" },
        capabilities = capabilities,
      }

      -- JSON
      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        capabilities = capabilities,
      }

      -- YAML
      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        capabilities = capabilities,
      }

      -- Bash
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        capabilities = capabilities,
      }

      -- TypeScript / JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
        capabilities = capabilities,
      }

      -- Svelte
      vim.lsp.config.svelte = {
        cmd = { "svelteserver", "--stdio" },
        filetypes = { "svelte" },
        root_markers = { "svelte.config.js", "svelte.config.cjs", "svelte.config.ts", "package.json", ".git" },
        capabilities = capabilities,
      }

      -- HTML
      vim.lsp.config.html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        capabilities = capabilities,
      }

      -- CSS
      vim.lsp.config.cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        capabilities = capabilities,
      }

      -- Tailwind CSS
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "less", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
        root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "postcss.config.js", "package.json", ".git" },
        capabilities = capabilities,
      }

      -- ESLint
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
        root_markers = {
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.json",
          "eslint.config.js",
          "eslint.config.cjs",
          "eslint.config.mjs",
          "package.json",
          ".git",
        },
        capabilities = capabilities,
      }

      -- OCaml / Reason / Dune (install with: opam install ocaml-lsp-server)
      --
      -- GUI Neovim often lacks `eval $(opam env)`. Spawning `ocamllsp` by absolute path
      -- still leaves Merlin/the compiler on the wrong toolchain unless the process gets an
      -- opam-shaped PATH. Prefer `opam exec` so the server matches the intended switch.
      --
      -- Resolution order:
      --   1. OPAMSWITCH env (name or path), if set — pairs well with direnv / desktop env.d
      --   2. Default switch read from `$OPAMROOT/config`, then
      --      `opam exec --switch=<that> -- ocamllsp` (matches `opam switch`; avoids bare
      --      `opam exec --` quirks under some LSP spawn environments)
      --   3. `opam exec -- ocamllsp` if the config file cannot be read
      --   4. `ocamllsp` on PATH, then any ~/.opam/*/bin/ocamllsp (last resort; weaker env)
      local function ocamllsp_cmd()
        local function find_opam()
          if vim.fn.executable("opam") == 1 then
            return "opam"
          end
          for _, p in ipairs({
            vim.fn.expand("~/.local/bin/opam"),
            "/opt/homebrew/bin/opam",
            "/usr/local/bin/opam",
            "/usr/bin/opam",
          }) do
            if vim.fn.executable(p) == 1 then
              return p
            end
          end
          return nil
        end

        local function opam_default_switch_from_config()
          local root = vim.env.OPAMROOT
          if root == nil or root == "" then
            root = vim.fn.expand("~/.opam")
          end
          local f = io.open(root .. "/config", "r")
          if not f then
            return nil
          end
          local content = f:read("*a")
          f:close()
          return content:match('switch:%s*"([^"]+)"')
        end

        local opam = find_opam()
        if opam then
          local sw = vim.env.OPAMSWITCH
          if sw ~= nil and sw ~= "" then
            return { opam, "exec", "--switch=" .. sw, "--", "ocamllsp" }
          end
          local cfg_sw = opam_default_switch_from_config()
          if cfg_sw ~= nil and cfg_sw ~= "" then
            return { opam, "exec", "--switch=" .. cfg_sw, "--", "ocamllsp" }
          end
          return { opam, "exec", "--", "ocamllsp" }
        end

        if vim.fn.executable("ocamllsp") == 1 then
          return { "ocamllsp" }
        end

        for _, path in ipairs(vim.fn.glob(vim.fn.expand("~/.opam/*/bin/ocamllsp"), false, true)) do
          if vim.fn.executable(path) == 1 then
            return { path }
          end
        end

        return { "ocamllsp" }
      end

      vim.lsp.config.ocamllsp = {
        cmd = ocamllsp_cmd(),
        filetypes = { "ocaml", "ocamlinterface", "ocamllex", "menhir", "reason", "dune" },
        -- Prefer Dune/opam roots so a parent repo `.git` (e.g. ~/Code) does not steal the
        -- workspace when this folder has its own `dune-project`.
        root_markers = { "dune-project", "dune-workspace", "*.opam", "esy.json", "package.json", ".git" },
        capabilities = capabilities,
      }

      -- R Language Server (optional - only if R is available)
      if vim.fn.executable("R") == 1 then
        vim.lsp.config.r_language_server = {
          cmd = { "R", "--slave", "-e", "languageserver::run()" },
          filetypes = { "r", "rmd" },
          root_markers = { ".git", "DESCRIPTION" },
          capabilities = capabilities,
        }
      end

      -- Auto-enable LSP servers when files are opened
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("LspAutoStart", {}),
        pattern = {
          "python", "lua", "markdown", "json", "jsonc", "yaml", "sh", "bash", "r", "rmd",
          "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte",
          "html", "css", "scss", "less",
          "ocaml", "ocamlinterface", "ocamllex", "menhir", "reason", "dune",
        },
        callback = function(args)
          local clients = vim.lsp.get_clients({ bufnr = args.buf })
          if #clients > 0 then
            return -- LSP already attached
          end

          -- Determine which LSP to start based on filetype
          local ft = vim.bo[args.buf].filetype
          local server_map = {
            python = "basedpyright",
            lua = "lua_ls",
            markdown = "marksman",
            json = "jsonls",
            jsonc = "jsonls",
            yaml = "yamlls",
            sh = "bashls",
            bash = "bashls",
            r = "r_language_server",
            rmd = "r_language_server",
            typescript = "ts_ls",
            typescriptreact = "ts_ls",
            javascript = "ts_ls",
            javascriptreact = "ts_ls",
            svelte = "svelte",
            html = "html",
            css = "cssls",
            scss = "cssls",
            less = "cssls",
            ocaml = "ocamllsp",
            ocamlinterface = "ocamllsp",
            ocamllex = "ocamllsp",
            menhir = "ocamllsp",
            reason = "ocamllsp",
            dune = "ocamllsp",
          }

          local server = server_map[ft]
          if server and vim.lsp.config[server] then
            vim.lsp.enable(server)
          end

          -- Additional web tooling servers that should run alongside base language server.
          local extra_servers = {
            typescript = { "tailwindcss", "eslint" },
            typescriptreact = { "tailwindcss", "eslint" },
            javascript = { "tailwindcss", "eslint" },
            javascriptreact = { "tailwindcss", "eslint" },
            svelte = { "tailwindcss", "eslint" },
            html = { "tailwindcss" },
            css = { "tailwindcss" },
            scss = { "tailwindcss" },
            less = { "tailwindcss" },
          }

          for _, extra in ipairs(extra_servers[ft] or {}) do
            if vim.lsp.config[extra] then
              vim.lsp.enable(extra)
            end
          end
        end,
      })

      -- Diagnostic signs
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
}
