vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── 視窗切換 ────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- ── 剪貼簿 ──────────────────────────────────────────────────────────
map("i", "<S-Insert>", "<C-R>+", opts)   -- 插入模式貼上系統剪貼簿
map("v", "<C-Insert>", '"+y', opts)      -- 選取後複製到系統剪貼簿

-- ── 編碼切換 (最重要) ────────────────────────────────────────────────
-- 用指定編碼重新讀取目前檔案。有未存檔修改時會先擋下來，避免不小心弄壞內容。
local function reload_with_encoding(enc)
  if vim.bo.modified then
    vim.notify("檔案有未儲存的修改，請先 :w 或 :e! 再切換編碼", vim.log.levels.WARN)
    return
  end
  if vim.fn.expand("%") == "" then
    vim.notify("目前 buffer 沒有對應檔案", vim.log.levels.WARN)
    return
  end
  vim.cmd("edit ++enc=" .. enc)
  vim.notify("以 " .. enc .. " 重新讀取: " .. vim.fn.expand("%:t"))
end

map("n", "<leader>big", function() reload_with_encoding("cp950") end,
  { desc = "以 cp950 (Big5) 重新讀取檔案" })
map("n", "<leader>utf", function() reload_with_encoding("utf-8") end,
  { desc = "以 utf-8 重新讀取檔案" })

-- ── log 高亮 ────────────────────────────────────────────────────────
-- 副檔名不是 .log 但內容長得像 log 的檔案，手動套用 log 配色。
map("n", "<leader>log", function()
  vim.bo.filetype = "log"
  vim.notify("filetype = log")
end, { desc = "把目前 buffer 當作 log 上色" })

-- ── 其他 ────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts) -- Esc 清掉搜尋高亮
map("v", "p", '"_dP', opts)                    -- visual 貼上時不覆蓋剪貼簿
