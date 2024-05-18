return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_gitignored = false,
        },
      },
      close_if_last_window = true,
    })
    vim.keymap.set('n', '<leader>nn', ':Neotree filesystem reveal left<CR>', {})
  end
}
