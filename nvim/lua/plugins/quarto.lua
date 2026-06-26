-- ===================================================================
-- Quarto: Scientific and Technical Publishing
-- ===================================================================

return {
  -- Quarto plugin
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown", "rmd" },
    cmd = { "QuartoPreview", "QuartoClosePreview", "QuartoSend", "QuartoSendAbove", "QuartoSendAll" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia", "bash", "lua" },
          chunks = "all", -- 'curly' or 'all'
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" }
          },
          completion = {
            enabled = true
          }
        },
        codeRunner = {
          enabled = true,
          default_method = "molten", -- 'molten' or 'slime'
          ft_runners = {
            python = "molten"
          },
          never_run = { "yaml" },
        },
        keymap = {
          hover = "K",
          definition = "gd",
          type_definition = "gD",
          rename = "<leader>lr",
          format = "<leader>lf",
          references = "gr",
          document_symbols = "gS",
        }
      })

      -- Keymaps for Quarto
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Quarto commands
      map("n", "<leader>qp", ":QuartoPreview<CR>", { desc = "Quarto Preview" })
      map("n", "<leader>qq", ":QuartoClosePreview<CR>", { desc = "Quarto Close Preview" })
      map("n", "<leader>qh", ":QuartoHelp ", { desc = "Quarto Help" })
      map("n", "<leader>qe", ":QuartoSendAbove<CR>", { desc = "Quarto Send Above" })
      map("n", "<leader>qa", ":QuartoSendAll<CR>", { desc = "Quarto Send All" })

      -- Code running
      map("n", "<leader>rc", ":.QuartoSend<CR>", { desc = "Run Current Line" })
      map("v", "<leader>rc", ":QuartoSend<CR>", { desc = "Run Selection" })
      map("n", "<leader>ra", ":QuartoSendAll<CR>", { desc = "Run All" })
    end,
  },

  -- Otter: Auto-completion and diagnostics in code chunks
  {
    "jmbuhr/otter.nvim",
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("otter").setup({
        lsp = {
          hover = {
            border = "rounded"
          }
        },
        buffers = {
          set_filetype = true,
          write_to_disk = false
        },
        strip_wrapping_quote_characters = { "'", '"', "`" }
      })
    end,
  },

  -- Molten: Jupyter kernel integration
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    cmd = {
      "MoltenInit",
      "MoltenEvaluateOperator",
      "MoltenEvaluateLine",
      "MoltenReevaluateCell",
      "MoltenEvaluateVisual",
      "MoltenShowOutput",
      "MoltenHideOutput",
      "MoltenDelete",
    },
    build = ":UpdateRemotePlugins",
    init = function()
      -- Settings
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      -- Keymaps for Molten
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Molten Init" })
      map("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "Molten Eval Operator" })
      map("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "Molten Eval Line" })
      map("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { desc = "Molten Re-eval Cell" })
      map("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten Eval Visual" })
      map("n", "<leader>mo", ":MoltenShowOutput<CR>", { desc = "Molten Show Output" })
      map("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Molten Hide Output" })
      map("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Molten Delete Cell" })
    end,
  },

  -- Image support for Molten
  {
    "3rd/image.nvim",
    ft = { "markdown", "quarto", "vimwiki", "python", "ipynb" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },

  -- Markdown preview (useful for Quarto/markdown files)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "quarto" },
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_filetypes = { 'markdown', 'quarto' }
      vim.g.mkdp_theme = 'dark'

      vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true })
    end,
  },

  -- NotebookNavigator: cell navigation and execution for %-format notebooks
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "echasnovski/mini.comment",
      "benlubas/molten-nvim",
      "anuvyklack/hydra.nvim",
    },
    keys = {
      { "]h", function() require("notebook-navigator").move_cell("d") end, desc = "Next cell" },
      { "[h", function() require("notebook-navigator").move_cell("u") end, desc = "Prev cell" },
      { "<leader>nx", function() require("notebook-navigator").run_cell() end, desc = "Run cell" },
      { "<leader>nX", function() require("notebook-navigator").run_and_move() end, desc = "Run cell and move" },
      { "<leader>na", function() require("notebook-navigator").run_all_cells() end, desc = "Run all cells" },
    },
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({
        activate_hydra_keys = "<leader>nh",
        show_hydra_hint = true,
        hydra_keys = {
          comment        = "c",
          run            = "X",
          run_and_move   = "x",
          move_up        = "k",
          move_down      = "j",
          add_cell_before = "a",
          add_cell_after  = "b",
          split_cell      = "s",
        },
        repl_provider = "molten",
      })

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
      end

      map("]h", function() nn.move_cell("d") end, "Next cell")
      map("[h", function() nn.move_cell("u") end, "Prev cell")
      map("<leader>nx", nn.run_cell,              "Run cell")
      map("<leader>nX", nn.run_and_move,          "Run cell and move")
      map("<leader>na", nn.run_all_cells,         "Run all cells")
    end,
  },

  -- Jupytext: transparent .ipynb <-> percent-format Python bridge
  {
    "GCBallesteros/jupytext.nvim",
    ft = { "ipynb" },
    config = true,  -- uses defaults: style="hydrogen", output_extension="auto"
  },
}
