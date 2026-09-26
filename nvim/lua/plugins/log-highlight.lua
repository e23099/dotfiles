-- log 檔語法高亮：時間戳、數字、路徑、ERROR/WARN/INFO 等級各有不同顏色。
-- 純 vim syntax 實作，不需要 treesitter 也不需要編譯器，在公司電腦也能用。
return {
  "fei6409/log-highlight.nvim",
  event = "BufReadPre", -- 需要在開檔前註冊 filetype 偵測規則
  opts = {
    -- 注意：外掛自帶的 ftdetect 已經處理 *.log 和 *_log，這裡不要再列一次，
    -- 否則 FileType 會觸發兩次、語法檔載入兩次。
    -- 這些副檔名直接當作 log
    extension = { "out", "err", "trace" },
    -- 這些檔名 (不含路徑) 也當作 log
    filename = { "messages", "syslog", "console", "nohup.out" },
    -- 檔名 pattern (lua pattern；nvim 會自動包成 ^...$，所以開頭要加 .*，結尾不要加 $)
    pattern = {
      ".*%.log%.%d+",          -- app.log.1, app.log.20
      ".*%.log%.[%d%-_]+",     -- app.log.2026-09-26
      ".*%.log%.txt",          -- app.log.txt
      ".*[%-_]log%.txt",       -- debug_log.txt, error-log.txt
      ".*%-log",               -- error-log (debug_log 已由外掛 ftdetect 處理)
    },
    -- 額外英文關鍵字 (大小寫敏感)。中文關鍵字在 after/syntax/log.vim，見該檔說明。
    keyword = {
      error   = { "FATAL", "Exception", "Traceback" },
      warning = { "WARNING", "Warn" },
      info    = { "Info" },
      debug   = { "Debug", "Trace", "VERBOSE" },
      pass    = { "PASS", "OK", "SUCCESS" },
    },
  },
}
