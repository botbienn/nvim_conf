return {
	{
        "rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
			})

			vim.cmd("colorscheme kanagawa")
		end,
	},
}
