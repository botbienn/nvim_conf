local autocmd = vim.api.nvim_create_autocmd
autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>vws", function()
            vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "<leader>vca", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>vrr", function()
            vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>vrn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_prev()
        end, opts)
    end,
})


autocmd({ "FileType", "BufRead", "BufNewFile" }, {
    pattern = { "*.ipynb" },
    callback = function()
        vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
        vim.keymap.set(
            "n",
            "<leader>e",
            ":MoltenEvaluateOperator<CR>",
            { silent = true, desc = "run operator selection" }
        )
        vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
        vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
        vim.keymap.set(
            "v",
            "<leader>r",
            ":<C-u>MoltenEvaluateVisual<CR>gv",
            { silent = true, desc = "evaluate visual selection" }
        )
    end,
})

autocmd({ "FileType", "BufRead", "BufNewFile" }, {
    pattern = { "*.hbs" },
    callback = function()
        print("File type set to html")
        vim.cmd("set filetype=html")
    end,
})

autocmd({ "FileType", "BufRead", "BufNewFile" }, {
    pattern = { "*.*" },
    callback = function()
        -- check if file type has no extension
        vim.cmd("set foldmethod=indent")
        vim.cmd("set foldnestmax=2")
    end,
})

autocmd({ "FileType", "BufRead", "BufNewFile" }, {
    callback = function()
        if vim.bo.filetype == "dbui" then
            vim.cmd("set foldmethod=manual")
            vim.cmd("set relativenumber")
            return;
        end
        -- check if file type has no extension
    end,
})
