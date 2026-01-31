return {
  -- TODO: make better background
  -- "rebelot/kanagawa.nvim",
  -- "rose-pine/neovim",
  "catppuccin/nvim",
  config = function()
    -- require("rose-pine").setup({
    -- 	variant = "auto", -- auto, main, moon, or dawn
    -- 	dark_variant = "main", -- main, moon, or dawn
    -- 	dim_inactive_windows = false,
    -- 	extend_background_behind_borders = true,
    -- })

    -- vim.cmd("colorscheme rose-pine")
    require("catppuccin").setup({
      transparent_background = true, -- disables setting the background color.
      flavour = "Mocha",
      float = {
        transparent = true, -- enable transparent floating windows
      },
      integrations = {
        cmp = true,
      },
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
