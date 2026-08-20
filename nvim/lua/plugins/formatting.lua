return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters (used by conform.nvim below)
          "clang-format",
          "shfmt",
          "stylua",
          "prettier",
          "taplo",
          "yamlfmt",
          "sql-formatter",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          local conform = require("conform")
          conform.format({
            async = true,
            lsp_fallback = true,
            timeout_ms = 3000,
          }, function(err)
            if err then
              vim.notify("Format failed: " .. err, vim.log.levels.ERROR)
            end
          end)
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          -- Systems / low-level
          c = { "clang-format" },
          cpp = { "clang-format" },
          cuda = { "clang-format" },
          objc = { "clang-format" },
          objcpp = { "clang-format" },
          proto = { "clang-format" },
          arduino = { "clang-format" },

          -- Scripting / app languages
          python = { "ruff_format", "ruff_organize_imports" },
          lua = { "stylua" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          vue = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          less = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier", "yamlfmt" },
          markdown = { "prettier" },
          toml = { "taplo" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          sql = { "sql_formatter" },
          graphql = { "prettier" },

          -- Optional: format via LSP when no dedicated formatter is configured
          -- (clangd, basedpyright, etc. — see lsp.lua)
        },
        format_on_save = false,
      })
    end,
  },
}
