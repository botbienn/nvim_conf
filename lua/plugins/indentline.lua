return {
    { -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = "ibl",
        opts = {
            exclude = {
                filetypes = { "dashboard",
                    "alpha",
                    "NvimTree",
                    "Outline",
                    "neo-tree",
                    "Trouble",
                    "lspinfo",
                    "checkhealth",
                    "TelescopePrompt",
                    "help",
                    "startify",
                    "DBBrowser",
                },
            }
        },
    },
}
