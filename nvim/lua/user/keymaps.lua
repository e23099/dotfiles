-- vim.api.nvim_set_keymap({mode}, {keymap}, {mapped_to}, {options})
local opts = { noremap = true , silent = true }

local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- window navigation
keymap('n', '<c-j>',  '<c-w>j', opts)
keymap('n', '<c-h>',  '<c-w>h', opts)
keymap('n', '<c-k>',  '<c-w>k', opts)
keymap('n', '<c-l>',  '<c-w>l', opts)

-- buffer navigation
keymap('n', '<s-h>', ':bprevious<cr>', opts)
keymap('n', '<s-l>', ':bnext<cr>', opts)
keymap('n', '<s-j>', 'gT', opts)
keymap('n', '<s-k>', 'gt', opts)

-- moving text
-- keymap("v", "<a-j>", ":m .+1<CR><s-v>", opts)
-- keymap("v", "<a-k>", ":m .-2<CR><s-v>", opts)
keymap("v", "p", '"_dP', opts)


-- NvimTreeToggle
keymap('n', '<leader>nn', ':NvimTreeToggle<CR>', {})

-- clipboard
keymap('i', '<S-Insert>', '<C-R>+', opts)
keymap('v', '<C-Insert>', '"*y', opts)
