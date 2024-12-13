vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<C-d>", function()
	require("neoscroll").ctrl_d({ duration = 50 })
	vim.cmd.normal("zz")
end)
vim.keymap.set("n", "<C-u>", function()
	require("neoscroll").ctrl_u({ duration = 50 })
	vim.cmd.normal("zz")
end)

vim.keymap.set("n", "J", "mzJ`z")

-- delete word in insert mode
vim.keymap.set("i", "<M-BS>", "<ESC>diwi")
vim.keymap.set("i", "<M-DEL>", "<ESC>dwi")

-- paste without replacing the buffer
vim.keymap.set("x", "<leader>p", [["_dP]])
-- delete without replacing the buffer
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- call terminal
--vim.keymap.set('n', '<leader>;', vim.cmd.terminal)
--vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
vim.keymap.set("n", "<leader>r", vim.diagnostic.goto_next, opts)

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- commentting
vim.keymap.set("n", "<leader>/", function()
	vim.cmd.norm("gcc")
end, { remap = true })

vim.keymap.set("v", "<leader>/", function()
	vim.cmd.norm("gc")
end, { remap = true })

local list = {'a','b'}

print(list[2])
