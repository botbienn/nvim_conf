local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "stevearc/overseer.nvim",      config = true },
    { "williamboman/mason.nvim" },
    { "jay-babu/mason-nvim-dap.nvim" },
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
    local dap = require("dap")

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
      port = 8123,
      executable = {
        command = "js-debug-adapter",
      }
    }

    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          console = "integratedTerminal", -- IMPORTANT
          outputCapture = "std",          -- IMPORTANT
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          console = "integratedTerminal",         -- IMPORTANT
          outputCapture = "std",                  -- IMPORTANT
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug web applications (client side)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch & Debug Chrome",
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:3000",
              }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = "inspector",
          sourceMaps = true,
          userDataDir = false,
        },
        -- Divider for the launch.json derived configs
        {
          name = "----- ↓ launch.json configs ↓ -----",
          type = "",
          request = "launch",
        },
      }
    end

    -- Signs
    for _, group in pairs({
      "DapBreakpoint",
      "DapBreakpointCondition",
      "DapBreakpointRejected",
      "DapLogPoint",
    }) do
      vim.fn.sign_define(group, { text = "●", texthl = group })
    end

    -- Avoid sudden buffer jumps during debugging
    dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

    ------------------------------------------------------------------
    -- Mason-nvim-dap automatic installation + automatic config
    ------------------------------------------------------------------
    require("mason-nvim-dap").setup({
      automatic_setup = true,
      ensure_installed = {
        -- "bash",
        -- "chrome",
        -- "codelldb",
        -- "python",
        -- "node2",
      },
      handlers = {}, -- implicit auto setup (replaces setup_handlers)
    })
  end,
}
