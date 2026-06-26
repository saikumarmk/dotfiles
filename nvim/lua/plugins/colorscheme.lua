-- ===================================================================
-- Color Schemes: vibrant dark default with familiar fallbacks
-- ===================================================================

return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        filter = "spectrum",
        inc_search = "background",
        styles = {
          comment = { italic = true },
          keyword = { italic = false },
          type = { italic = false },
          storageclass = { italic = false },
          structure = { italic = false },
          parameter = { italic = false },
          annotation = { italic = false },
          tag_attribute = { italic = false },
        },
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = false,
            underline_fill = false,
            bold = true,
          },
          indent_blankline = {
            context_highlight = "pro",
            context_start_underline = false,
          },
        },
        override = function(scheme)
          return {
            Normal = { bg = "#17161d" },
            NormalNC = { bg = "#17161d" },
            SignColumn = { bg = "#17161d" },
            EndOfBuffer = { fg = "#17161d", bg = "#17161d" },
            NormalFloat = { bg = "#221f22" },
            FloatBorder = { fg = scheme.base.cyan, bg = "#221f22" },
            CursorLine = { bg = "#221f22" },
            Visual = { bg = "#403e41" },
            LineNr = { fg = "#727072" },
            CursorLineNr = { fg = scheme.base.yellow, bold = true },
            WinSeparator = { fg = "#403e41" },
            PmenuSel = { bg = scheme.base.magenta, fg = "#19181a", bold = true },
            Search = { bg = scheme.base.yellow, fg = "#19181a", bold = true },
            IncSearch = { bg = scheme.base.red, fg = "#19181a", bold = true },
            ["@keyword"] = { fg = scheme.base.red, bold = true },
            ["@keyword.function"] = { fg = scheme.base.red, bold = true },
            ["@function"] = { fg = scheme.base.green },
            ["@function.method"] = { fg = scheme.base.green },
            ["@string"] = { fg = scheme.base.yellow },
            ["@variable"] = { fg = scheme.base.white },
            ["@type"] = { fg = scheme.base.cyan },
            ["@constant"] = { fg = scheme.base.magenta },
            ["@property"] = { fg = scheme.base.blue },
            NeoTreeNormal = { bg = "#17161d" },
            NeoTreeNormalNC = { bg = "#17161d" },
            NeoTreeEndOfBuffer = { fg = "#17161d", bg = "#17161d" },
            NeoTreeWinSeparator = { fg = "#403e41", bg = "#17161d" },
            NeoTreeCursorLine = { bg = "#221f22" },
            NeoTreeFloatBorder = { fg = scheme.base.cyan, bg = "#17161d" },
            NeoTreeTitleBar = { fg = "#19181a", bg = scheme.base.magenta, bold = true },
            NeoTreeDirectoryName = { fg = scheme.base.cyan },
            NeoTreeDirectoryIcon = { fg = scheme.base.blue },
            NeoTreeFileNameOpened = { fg = scheme.base.yellow, bold = true },
            BufferLineFill = { bg = "#17161d" },
            TabLineFill = { bg = "#17161d" },
          }
        end,
      })

      local function apply_dark_ui_overrides()
        local near_black = "#17161d"
        local panel = "#221f22"
        local border = "#403e41"

        local highlights = {
          Normal = { bg = near_black },
          NormalNC = { bg = near_black },
          SignColumn = { bg = near_black },
          EndOfBuffer = { fg = near_black, bg = near_black },
          NeoTreeNormal = { bg = near_black },
          NeoTreeNormalNC = { bg = near_black },
          NeoTreeEndOfBuffer = { fg = near_black, bg = near_black },
          NeoTreeWinSeparator = { fg = border, bg = near_black },
          NeoTreeCursorLine = { bg = panel },
          BufferLineFill = { bg = near_black },
          TabLineFill = { bg = near_black },
        }

        for group, opts in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, opts)
        end
      end

      vim.o.background = "dark"
      vim.cmd.colorscheme("monokai-pro-spectrum")
      apply_dark_ui_overrides()

      vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
        group = vim.api.nvim_create_augroup("UserDarkUiOverrides", { clear = true }),
        pattern = { "*", "neo-tree" },
        callback = apply_dark_ui_overrides,
      })

      vim.keymap.set("n", "<leader>um", function()
        vim.cmd("MonokaiPro")
      end, {
        silent = true,
        desc = "Select Monokai Pro filter",
      })
    end,
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    cmd = "CyberdreamTheme",
    config = function()
      require("cyberdream").setup({
        variant = "default",
        transparent = false,
        saturation = 1,
        italic_comments = true,
        borderless_pickers = true,
        terminal_colors = true,
        cache = false,
        extensions = {
          default = false,
          base = true,
          alpha = true,
          cmp = true,
          gitsigns = true,
          lazy = true,
          lualine = true,
          noice = true,
          notify = true,
          telescope = true,
          treesitter = true,
          whichkey = true,
        },
      })

      vim.api.nvim_create_user_command("CyberdreamTheme", function()
        vim.cmd.colorscheme("cyberdream")
      end, {})
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    cmd = "OneDark",
    config = function()
      require("onedark").setup({
        style = "deep",
        transparent = false,
        term_colors = true,
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      })

      vim.api.nvim_create_user_command("OneDark", function()
        require("onedark").load()
      end, {})
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    cmd = "CatppuccinMocha",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          neotree = true,
          telescope = true,
          treesitter = true,
          mason = true,
          which_key = true,
          dap = {
            enabled = true,
            enable_ui = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      })

      vim.api.nvim_create_user_command("CatppuccinMocha", function()
        vim.cmd.colorscheme("catppuccin")
      end, {})
    end,
  },
}
