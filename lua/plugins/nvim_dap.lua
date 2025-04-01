return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- Runs preLaunchTask / postDebugTask if present
        { "stevearc/overseer.nvim", config = true },
    },
    keys = {
        {
            "<leader>ds",
            function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.scopes, { border = "rounded" })
            end,
            desc = "DAP Scopes",
        },
        {
            "<F1>",
            function() require("dap.ui.widgets").hover(nil, { border = "rounded" }) end,
            desc = "DAP Hover",
        },
        { "<F4>",  "<CMD>DapTerminate<CR>",                       desc = "DAP Terminate" },
        { "<F5>",  "<CMD>DapContinue<CR>",                        desc = "DAP Continue" },
        { "<F6>",  function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<F9>",  "<CMD>DapToggleBreakpoint<CR>",                desc = "Toggle Breakpoint" },
        { "<F10>", "<CMD>DapStepOver<CR>",                        desc = "Step Over" },
        { "<F11>", "<CMD>DapStepInto<CR>",                        desc = "Step Into" },
        { "<F12>", "<CMD>DapStepOut<CR>",                         desc = "Step Out" },
        { "<F17>", function() require("dap").run_last() end,      desc = "Run Last" },
        {
            "<F21>",
            function()
                vim.ui.input(
                    { prompt = "Breakpoint condition: " },
                    function(input) require("dap").set_breakpoint(input) end
                )
            end,
            desc = "Conditional Breakpoint",
        },
        {
            "<A-r>",
            function() require("dap").repl.toggle(nil, "tab split") end,
            desc = "Toggle DAP REPL",
        },
    },
    config = function()
        -- Signs
        for _, group in pairs({
            "DapBreakpoint",
            "DapBreakpointCondition",
            "DapBreakpointRejected",
            "DapLogPoint",
        }) do
            vim.fn.sign_define(group, { text = "●", texthl = group })
        end

        -- Setup

        -- Decides when and how to jump when stopping at a breakpoint
        -- The order matters!
        --
        -- (1) If the line with the breakpoint is visible, don't jump at all
        -- (2) If the buffer is opened in a tab, jump to it instead
        -- (3) Else, create a new tab with the buffer
        --
        -- This avoid unnecessary jumps
        local dap = require("dap")
        dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

        -- Adapters
        -- C, C++, Rust
        -- require("plugins.dap.codelldb")
        -- dap.adapters.codelldb = {
        --     type = "server",
        --     port = "${port}",
        --     executable = {
        --         command = "codelldb",
        --         args = { "--port", "${port}" },
        --     },
        -- }

        -- dap.configurations.cpp = {
        --     {
        --         name = 'Launch',
        --         type = 'codelldb',
        --         request = 'launch',
        --         program = function()
        --             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --         end,
        --         cwd = '${workspaceFolder}',
        --         stopOnEntry = false,
        --         args = {},
        --
        --         -- 💀
        --         -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --         --
        --         --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --         --
        --         -- Otherwise you might get the following error:
        --         --
        --         --    Error on launch: Failed to attach to the target process
        --         --
        --         -- But you should be aware of the implications:
        --         -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        --         -- runInTerminal = false,
        --     },
        -- }
        -- Python
        -- require("plugins.dap.debugpy")
        -- JS, TS
        -- require("plugins.dap.js-debug-adapter")
    end,
}
