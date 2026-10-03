local opt = vim.opt

-- ── 編碼 ────────────────────────────────────────────────────────────
-- 開檔時依序嘗試這些編碼；utf-8 解不開的檔案會自動落到 cp950 (Big5)。
-- 大多數中文舊文檔因此可以直接開。若判斷錯誤，用 <leader>big / <leader>utf 手動切換。
opt.encoding = "utf-8"
opt.fileencodings = { "ucs-bom", "utf-8", "cp950", "latin1" }

-- ── 外觀 ────────────────────────────────────────────────────────────
opt.termguicolors = true
opt.number = true
opt.cursorline = true
opt.signcolumn = "no"     -- 沒有 LSP/git 外掛，不需要留這一欄
opt.wrap = false          -- log 通常一行很長，不折行比較好讀
opt.scrolloff = 3
opt.showmode = false      -- 狀態列已經會顯示模式
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", extends = "»", precedes = "«", nbsp = "␣" }

-- 內建狀態列：檔名 [編碼][換行格式] 檔案類型 ... 行:欄 百分比
-- 中間那格會顯示 utf-8 / cp950，一眼就知道目前用什麼編碼看檔案。
opt.laststatus = 2
opt.statusline = table.concat({
  " %<%f %h%m%r",
  " [%{&fenc!=''?&fenc:&enc}][%{&ff}]",
  " %y",
  "%=",
  " %l:%c  %P ",
})

-- ── 編輯 ────────────────────────────────────────────────────────────
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.mouse = "a"
opt.mousescroll = "ver:3,hor:5" -- Alt+滾輪水平捲動一次 5 欄 (跟 Notepad++ 差不多)
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 300
opt.timeoutlen = 500

-- ── 檔案 ────────────────────────────────────────────────────────────
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- ── 效能 ────────────────────────────────────────────────────────────
opt.synmaxcol = 500       -- 超長行只對前 500 欄做語法高亮，避免大 log 卡頓
