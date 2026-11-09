return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
	},

	config = function()
		-- Open a Markdown file in Obsidian and focus its window (see ~/dotfiles/.local/scripts/obsidian-open)
		local function open_in_obsidian(path)
			if not path or not path:match("%.md$") then
				vim.notify("Not a .md file: " .. tostring(path), vim.log.levels.WARN)
				return
			end
			vim.system({ "obsidian-open", path }, {}, function(res)
				if res.code ~= 0 then
					vim.schedule(function()
						vim.notify("obsidian-open failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
					end)
				end
			end)
		end

		-- Picker stays open so more files can be sent to Obsidian
		local function browser_open_in_obsidian()
			local entry = require("telescope.actions.state").get_selected_entry()
			open_in_obsidian(entry and (entry.path or entry.value))
		end

		local obsidian_mappings = {
			i = { ["<C-y>"] = browser_open_in_obsidian },
			n = { ["O"] = browser_open_in_obsidian },
		}

		require("telescope").setup({
			pickers = {
				find_files = { mappings = obsidian_mappings },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
				file_browser = {
					hijack_netrw = true,
					mappings = obsidian_mappings,
				},
			},
		})
		vim.g.loaded_netrwPlugin = 1
		vim.g.loaded_netrw = 1
		require("telescope").load_extension("file_browser")
		vim.keymap.set("n", "<leader>pv", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
		vim.keymap.set("n", "<leader>po", function() open_in_obsidian(vim.fn.expand("%:p")) end, { desc = "Open current file in Obsidian" })
    vim.keymap.set('n', '<leader>sr', function() require('telescope.builtin').lsp_references() end, { noremap = true, silent = true })

		-- Alternatively, using lua API

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
	end,
}
