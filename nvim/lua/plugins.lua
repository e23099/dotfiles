require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use {
        'itchyny/lightline.vim',
	config = function() vim.g.lightline = { colorscheme = 'wombat' } end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function() 
            require("nvim-tree").setup {
                view = {
                    mappings = {
                        custom_only = false,
                        list = {
                            { key = "t", action = "tabnew" },
                            { key = "v", action = "split" },
                        }
                    }
                }
            }
        end,
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
end)


vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
