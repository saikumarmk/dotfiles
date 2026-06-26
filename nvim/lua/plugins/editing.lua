return {
  -- Aerial: symbol outline panel (functions, classes, etc.)
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>lo", "<cmd>AerialToggle!<CR>", desc = "Symbol outline" },
      { "[s", "<cmd>AerialPrev<CR>",            desc = "Prev symbol" },
      { "]s", "<cmd>AerialNext<CR>",            desc = "Next symbol" },
    },
    config = function()
      require("aerial").setup({
        backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
        layout = {
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 20,
          default_direction = "prefer_right",
          placement = "window",
        },
        attach_mode = "window",
        close_automatic_events = { "unsupported" },
        keymaps = {
          ["?"]  = "actions.show_help",
          ["g?"] = "actions.show_help",
          ["<CR>"]  = "actions.jump",
          ["<2-LeftMouse>"] = "actions.jump",
          ["o"]  = "actions.jump",
          ["p"]  = "actions.scroll",
          ["[["] = "actions.prev",
          ["]]"] = "actions.next",
          ["q"]  = "actions.close",
        },
        show_guides = true,
        filter_kind = {
          "Class", "Constructor", "Enum", "Function",
          "Interface", "Module", "Method", "Struct",
        },
        highlight_on_hover = true,
        autojump = false,
      })
    end,
  },

  -- Better escape: map jk to Esc in insert mode
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen,
        default_mappings = false,
        mappings = {
          i = { j = { k = "<Esc>" } },
          c = { j = { k = "<Esc>" } },
        },
      })
    end,
  },
}
