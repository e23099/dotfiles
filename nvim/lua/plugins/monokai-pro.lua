return {
  "loctvl842/monokai-pro.nvim",
  config = function()
    require("monokai-pro").setup({
      devicons = true,
    })
    vim.cmd([[colorscheme monokai-pro]])
  end
}
