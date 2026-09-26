return {
  "loctvl842/monokai-pro.nvim",
  lazy = false,
  priority = 1000, -- 配色要最先載入
  config = function()
    require("monokai-pro").setup({
      devicons = false, -- 沒裝 nvim-web-devicons
    })
    vim.cmd.colorscheme("monokai-pro")
  end,
}
