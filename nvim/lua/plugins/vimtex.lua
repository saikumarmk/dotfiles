-- ===================================================================
-- VimTeX: LaTeX editing and live compilation
-- ===================================================================

return {
  {
    "lervag/vimtex",
    lazy = false, -- must NOT be lazy loaded
    init = function()
      -- PDF viewer (zathura supports forward/inverse search on Linux)
      vim.g.vimtex_view_method = "zathura"

      -- Compiler: latexmk with continuous compilation for live preview
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".aux",
        out_dir = "",
        callback = 1,
        continuous = 1, -- recompile on save automatically
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",       -- enables forward/inverse search
          "-interaction=nonstopmode",
        },
      }

      -- Disable all default <localleader>l mappings; we remap to <leader>l below
      vim.g.vimtex_mappings_enabled = 0

      -- Suppress insert mode mappings (clash with cmp)
      vim.g.vimtex_imaps_enabled = 0

      -- Quickfix: open on error but don't steal focus, ignore warnings
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_open_on_warning = 0

      -- Concealment: greek/symbols in math, not fracs/super-sub (too noisy)
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 0,
        greek = 1,
        math_bounds = 0,
        math_delimiters = 1,
        math_fracs = 0,
        math_super_sub = 0,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }
    end,
    config = function()
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "latex" },
        callback = function()
          -- Re-label the <leader>l group for this buffer so which-key shows it
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "<leader>l", group = "LSP / LaTeX", buffer = 0 },
            })
          end

          -- Compilation
          map("<leader>ll", "<cmd>VimtexCompile<cr>",        "LaTeX compile (toggle)")
          map("<leader>lk", "<cmd>VimtexStop<cr>",           "LaTeX stop compiler")
          map("<leader>lK", "<cmd>VimtexStopAll<cr>",        "LaTeX stop all")
          -- View
          map("<leader>lv", "<cmd>VimtexView<cr>",           "LaTeX view PDF")
          -- Info / errors
          map("<leader>li", "<cmd>VimtexInfo<cr>",           "LaTeX info")
          map("<leader>lo", "<cmd>VimtexCompileOutput<cr>",  "LaTeX compiler output")
          map("<leader>le", "<cmd>VimtexErrors<cr>",         "LaTeX errors (quickfix)")
          -- TOC
          map("<leader>lt", "<cmd>VimtexTocOpen<cr>",        "LaTeX TOC open")
          map("<leader>lT", "<cmd>VimtexTocToggle<cr>",      "LaTeX TOC toggle")
          -- Utilities
          map("<leader>lw", "<cmd>VimtexCountWords<cr>",     "LaTeX word count")
          map("<leader>lc", "<cmd>VimtexClean<cr>",          "LaTeX clean aux files")
          map("<leader>lC", "<cmd>VimtexClean!<cr>",         "LaTeX clean all output")
          map("<leader>lx", "<cmd>VimtexReload<cr>",         "LaTeX reload plugin")
        end,
      })
    end,
  },
}
