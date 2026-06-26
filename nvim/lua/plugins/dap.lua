-- ===================================================================
-- DAP: Debug Adapter Protocol for Python
-- ===================================================================

return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local launch = require("config.dap_launch")

      -- Merged into every Python launch config unless overridden per-config
      dap.defaults.python = {
        justMyCode = false,
      }

      -- DAP UI setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Virtual text setup
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
      })

      -- Python + launch templates (see lua/config/dap_launch.lua)
      launch.setup()

      vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
        group = vim.api.nvim_create_augroup("DapProjectConfigs", { clear = true }),
        callback = function()
          launch.refresh()
        end,
      })

      -- DAP event listeners
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "", linehl = "", numhl = "" })

      -- Keymaps
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      keymap("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
      keymap("n", "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
      keymap("n", "<leader>dL", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, opts)
      keymap("n", "<leader>dc", function()
        launch.pick_config()
      end, opts)
      keymap("n", "<leader>dA", function()
        launch.run_current_file_with_args()
      end, opts)
      keymap("n", "<leader>dn", function()
        launch.template_new()
      end, opts)
      keymap("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>", opts)
      keymap("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>", opts)
      keymap("n", "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", opts)
      keymap("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<CR>", opts)
      keymap("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", opts)
      keymap("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", opts)
      keymap("n", "<leader>dt", "<cmd>lua require('dap').terminate()<CR>", opts)

      -- Python-specific keymaps
      keymap("n", "<leader>dpm", "<cmd>lua require('dap-python').test_method()<CR>", opts)
      keymap("n", "<leader>dpc", "<cmd>lua require('dap-python').test_class()<CR>", opts)
      keymap("v", "<leader>dps", "<Esc><cmd>lua require('dap-python').debug_selection()<CR>", opts)
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },

  -- Virtual text for DAP
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
  },

  -- Python DAP
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
