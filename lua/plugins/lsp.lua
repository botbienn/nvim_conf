return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "rafamadriz/friendly-snippets",
    },

    config = function()
        local luasnip = require("luasnip")
        local types = require("luasnip.util.types")
        require("luasnip.loaders.from_vscode").lazy_load()

        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                -- lsp
                "lua_ls",
                "rust_analyzer",
                "pyright",
                "ruff",
                "ts_ls",
                "html",
                "tailwindcss",
                "clangd",
                -- formatter
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                            },
                        },
                    })
                end,

                ["html"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.html.setup({
                        capabilities = capabilities,
                        config = {
                            filetypes = { "html", "templ", "hbs" },
                            format = {
                                templating = true,
                                wrapLineLength = 120,
                                wrapAttributes = "auto",
                            },
                            hover = {
                                documentation = true,
                                references = true,
                            },
                        },
                    })
                end,
            },
        })

        luasnip.setup({
            history = true,
            delete_check_events = "TextChanged",
            -- Display a cursor-like placeholder in unvisited nodes
            -- of the snippet.
            ext_opts = {
                [types.insertNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                },
            },
            option = { show_autosnippets = true },
        })

        vim.keymap.set({ "i", "s" }, "<C-K>", function()
            luasnip.jump(1)
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-J>", function()
            luasnip.jump(-1)
        end, { silent = true })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            -- preselect = true,
            -- completion = { completeopt = "menu" },

            experimental = {
                -- ghost_text = true,
                ghost_text = false,
            },

            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

                    -- For `mini.snippets` users:
                    -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                    -- insert({ body = args.body }) -- Insert at cursor
                    -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                    -- require("cmp.config").set_onetime({ sources = {} })
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "luasnip" }, -- For luasnip users.
                { name = "nvim_lsp" },
                { name = "vim-dadbod-completion" },
            }, {
                -- { name = "buffer" },
            }),
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
