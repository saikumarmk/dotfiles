-- ===================================================================
-- Terminal Integration: Toggleterm
-- ===================================================================

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    -- Specific terminal instances
    local Terminal = require("toggleterm.terminal").Terminal

    -- Python REPL
    local python = Terminal:new({
      cmd = "python3",
      hidden = true,
      direction = "float",
    })

    function _PYTHON_TOGGLE()
      python:toggle()
    end

    -- R REPL
    local r = Terminal:new({
      cmd = "R",
      hidden = true,
      direction = "float",
    })

    function _R_TOGGLE()
      r:toggle()
    end

    -- Keymaps for custom terminals
    vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>tr", "<cmd>lua _R_TOGGLE()<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { noremap = true, silent = true })
  end,
}
