-- vim.api.nvim_set_keymap({mode}, {key}, {mapped_to}, {options})
local opts = { noremap = true , silent = true }
local keymap = vim.api.nvim_set_keymap
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- window navigation
keymap('n', '<c-j>',  '<c-w>j', opts)
keymap('n', '<c-h>',  '<c-w>h', opts)
keymap('n', '<c-k>',  '<c-w>k', opts)
keymap('n', '<c-l>',  '<c-w>l', opts)

-- clipboard
keymap('i', '<S-Insert>', '<C-R>+', opts)
keymap('v', '<C-Insert>', '"*y', opts)

-- encoding
keymap('n', '<leader>big', ":execute ':edit ++enc=cp950 '.expand('%')<CR>", opts) -- edit current file in big5(cp950) char-set.
