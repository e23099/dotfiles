-- 精簡版 nvim 設定：重點是 (1) cp950/Big5 文檔可開 (2) log 類文件有舒服的顏色。
-- 外掛只有兩個：配色 + log 語法高亮，其餘全部用內建功能。

vim.loader.enable() -- 快取 lua 模組，加速啟動

-- bootstrap lazy.nvim (外掛管理器)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("autocmds")

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- 關掉用不到的內建外掛，減少啟動時間
      disabled_plugins = {
        "gzip", "tarPlugin", "zipPlugin",
        "tohtml", "tutor", "netrwPlugin",
      },
    },
  },
})
