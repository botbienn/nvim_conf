-- nvim-treesitter `main` branch. Its setup() no longer reads ensure_installed / highlight / indent,
-- so parsers are installed with install() and highlighting is started per buffer below.
-- Needs the `tree-sitter` CLI on PATH to build parsers (Arch: tree-sitter-cli).
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false, -- the main branch does not support lazy-loading
    config = function()
        require("nvim-treesitter").install({
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "sql", "templ", "python",
            "gdscript", "godot_resource", "gdshader",
            "go", "gomod", "gosum", "yaml", "json", "toml", "html", "css", "tsx",
            "dockerfile", "make", "ini", "diff", "gitignore", "requirements",
        })


        -- Start treesitter on any buffer whose language has a parser; pcall skips the rest.
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if not pcall(vim.treesitter.start, args.buf) then
                    return
                end
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                -- Keep Vim's regex syntax running alongside treesitter for markdown, as before.
                if vim.bo[args.buf].filetype == "markdown" then
                    vim.bo[args.buf].syntax = "on"
                end
            end,
        })
    end,
}
