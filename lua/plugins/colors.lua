return {
	{
		-- "rebelot/kanagawa.nvim",
		"rose-pine/neovim",
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},
}
