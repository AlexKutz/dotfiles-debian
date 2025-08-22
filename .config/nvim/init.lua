require("config.lazy")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

local map = vim.api.nvim_set_keymap

map("n", "<C-j>", "<Esc>:FzfLua colorschemes<CR>", {})
