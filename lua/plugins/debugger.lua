return {
    -- for C, C++, RUST: first install lldb -> put into $PATH
    -- details guide here:
    -- https://igorlfs.github.io/neovim-cpp-dbg
    {
        "nvim-neotest/nvim-nio",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                },
            }
        end
    },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function(_, opts)
            --local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            local path = "~/miniconda3/bin/python3.12"
            require("dap-python").setup(path)
        end
    },
    vim.keymap.set('n', '<leader>db', vim.cmd['DapToggleBreakpoint']),
    vim.keymap.set('n', '<leader>dpr', function()
        require('dap-python').test_method()
    end
    ),
    vim.keymap.set('n', '<F5>', vim.cmd['DapContinue']),
    vim.keymap.set('n', '<F10>', vim.cmd['DapStepOver']),
    vim.keymap.set('n', '<F11>', vim.cmd['DapStepInto']),
}
