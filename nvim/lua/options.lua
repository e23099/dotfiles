vim.opt.expandtab = true    -- convert tabs to spaces
vim.opt.tabstop = 2         -- insert 2 spaces for a tab
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2      -- the number of spaces inserted for each indentation
vim.opt.cursorline = true   -- highlight the current line
vim.opt.number = true       -- set numbered lines

vim.opt.backup = false      -- creates a backup file
vim.opt.swapfile = false    -- creates a swapfile
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.undofile = true     -- enable persistent undo
vim.opt.updatetime = 300    -- faster completion (4000ms default)
