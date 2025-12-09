return {
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
    end,
    vim.keymap.set('n', '<leader>dpr', function()
        require('dap-python').test_method()
    end),
}
