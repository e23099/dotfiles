local augroup = vim.api.nvim_create_augroup("user", { clear = true })

-- ── 大檔案保護 ──────────────────────────────────────────────────────
-- 超過 1MB：關掉 undofile。nvim 讀檔時若 undofile 開著，會對整個檔案算一次
--   SHA-256 拿來比對 undo 檔 (不管 undo 檔存不存在)，15MB 的 log 要多花 ~35ms。
-- 超過 10MB (通常是 log)：再關掉語法高亮、折疊、undo 記錄，避免開檔卡死。
local NO_UNDO_FILE = 1 * 1024 * 1024
local BIG_FILE = 10 * 1024 * 1024
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup,
  callback = function(ev)
    local ok, stat = pcall(vim.uv.fs_stat, ev.match)
    if not (ok and stat) then return end

    if stat.size > NO_UNDO_FILE then
      vim.bo[ev.buf].undofile = false
    end
    if stat.size <= BIG_FILE then return end

    vim.b[ev.buf].bigfile = true
    vim.bo[ev.buf].swapfile = false
    vim.bo[ev.buf].undolevels = -1
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.list = false

    vim.api.nvim_create_autocmd("BufReadPost", {
      buffer = ev.buf, once = true,
      callback = function()
        -- filetype 偵測 (含外掛的 ftdetect) 也在 BufReadPost 觸發，
        -- 用 schedule 排到它們全部跑完之後再關，才不會被蓋回去。
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(ev.buf) then return end
          vim.bo[ev.buf].filetype = ""
          vim.api.nvim_buf_call(ev.buf, function() vim.cmd("syntax clear") end)
          vim.notify(("大檔案模式：已關閉語法高亮 (%d MB)，需要時可用 <leader>log 手動開啟")
            :format(math.floor(stat.size / 1024 / 1024)))
        end)
      end,
    })
  end,
})

-- ── 記住上次游標位置 ────────────────────────────────────────────────
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── 複製時短暫高亮 ──────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})
