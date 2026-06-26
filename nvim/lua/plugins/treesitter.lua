-- ===================================================================
-- Treesitter: Better syntax highlighting and code understanding
-- ===================================================================
--
-- NOTE: nvim-treesitter dropped the old `nvim-treesitter.configs` module.
-- Highlighting is now via Neovim 0.11+ built-in vim.treesitter.
-- Textobject keymaps are set directly via the textobjects API.
-- ===================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- New API: setup() only accepts { install_dir = "..." } (optional)
    require("nvim-treesitter").setup()

    -- Parser installation is handled by lazy.nvim's build hook and one-off
    -- explicit installs. Avoid kicking off async downloads on every startup.

    -- Enable built-in treesitter highlighting and indentation per filetype
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang then
          vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
      end,
    })

    -- Textobject keymaps — new API requires direct calls (no more configs.setup)
    local select = require("nvim-treesitter-textobjects.select")
    local move   = require("nvim-treesitter-textobjects.move")

    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Select outer function" })
    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Select inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Select outer class" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Select inner class" })

    vim.keymap.set("n", "]f", function()
      move.goto_next_start("@function.outer")
    end, { desc = "Next function start" })
    vim.keymap.set("n", "]c", function()
      move.goto_next_start("@class.outer")
    end, { desc = "Next class start" })
    vim.keymap.set("n", "]F", function()
      move.goto_next_end("@function.outer")
    end, { desc = "Next function end" })
    vim.keymap.set("n", "]C", function()
      move.goto_next_end("@class.outer")
    end, { desc = "Next class end" })
    vim.keymap.set("n", "[f", function()
      move.goto_previous_start("@function.outer")
    end, { desc = "Prev function start" })
    vim.keymap.set("n", "[c", function()
      move.goto_previous_start("@class.outer")
    end, { desc = "Prev class start" })
    vim.keymap.set("n", "[F", function()
      move.goto_previous_end("@function.outer")
    end, { desc = "Prev function end" })
    vim.keymap.set("n", "[C", function()
      move.goto_previous_end("@class.outer")
    end, { desc = "Prev class end" })
  end,
}
