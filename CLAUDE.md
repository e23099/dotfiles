# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 這個 repo 是什麼

個人 dotfiles：在新機器上 `git clone` 後跑 repo 根目錄的 `install-*.ps1`，就完成常用程式的設定。目前以 Windows 為主 (nvim、wezterm、Windows 系統調整)；`tmux/` 給 Linux 用，`require.md` (Arch)、`ubt-setup.md` (Ubuntu) 只是手動安裝筆記，沒有對應腳本。

沒有 build / lint / 測試。驗證方式就是實際執行腳本，例如：

```powershell
powershell -ExecutionPolicy Bypass -File .\install-nvim.ps1            # -SkipPlugins 只建 junction
powershell -ExecutionPolicy Bypass -File .\install-fixtextscale.ps1    # -Scale 150 / -Uninstall
nvim --headless "+Lazy! restore" +qa                                   # 依 lazy-lock.json 裝外掛
```

## 架構與慣例

- **設定檔用 link 指回 repo，不複製**：程式讀的設定位置 link 到 repo 內的檔案，改 repo 即時生效。優先用 junction (不需管理員/開發者模式)，例如 `%LOCALAPPDATA%\nvim` → `nvim/`；wezterm 的 `%USERPROFILE%\.wezterm.lua` 是單一檔案只能用 symlink，目前還是手動 (見 `setup.md`)。
- **install 腳本放 repo 根目錄，命名 `install-<名稱>.ps1`**；被排程或其他腳本呼叫的輔助腳本放 `windows/`。腳本用 `$PSScriptRoot` 找 repo 內的檔案，不寫死 clone 路徑。
- **install 腳本要可重複執行且不破壞既有設定**：已正確設定就跳過；既有設定先備份成 `<名稱>.bak-<yyyyMMdd-HHmmss>`，不直接刪除；指向別處的 link 只移除 link 本身。
- **目標環境是公司電腦上的 Windows PowerShell 5.1**：
  - 盡量不需要管理員權限 (排程用目前使用者 + `LeastPrivilege`)。
  - 用法說明一律寫 `powershell -ExecutionPolicy Bypass -File ...`，因為執行原則可能被擋。
  - 含中文的 `.ps1` 必須存成 **UTF-8 with BOM**，否則 5.1 會用 cp950 讀壞。不能用 `&&`、`??` 等 PS7 語法。
  - 背景排程用 `conhost.exe --headless powershell.exe ...` 執行，避免閃視窗。
- `.gitattributes` 設定所有文字檔 `eol=lf`，讓同一份設定在 Windows / Linux 一致。
- 註解、README、commit 訊息用繁體中文。Commit 格式如 `add install-nvim.ps1: <說明>` 或 `wezterm: <說明>`。
- 新增 install 腳本時，在 `README.md` 補一段：做什麼、怎麼跑、有哪些參數。`setup.md` 放各程式的手動設定方式與常用按鍵表，改了按鍵要同步更新。

## 各設定重點

- **nvim**：刻意精簡，目標是 (1) 能開 cp950/Big5 檔案 (開檔依 utf-8 → cp950 偵測) (2) log 檔有好看的顏色。只有兩個外掛 (配色 + log 高亮，`nvim/lua/plugins/`)，其餘用內建功能；新增外掛前先確認真的需要。lazy.nvim 由 `init.lua` 自動 bootstrap，`lazy-lock.json` 要 commit。`tmp/` (gitignored) 放測試 log 高亮用的範例 log。
- **Ctrl+h/j/k/l 跨 pane 移動** 在 wezterm (`wezterm/wezterm.lua`) 與 tmux (`tmux/tmux.conf`) 都有實作：前景是 nvim 時把按鍵放行給 nvim 自己切 split，否則由終端機切 pane。改其中一邊時注意另一邊行為一致。
- wezterm 設定中有寫死本機路徑 (`default_cwd = 'D:/Work'`)，`setup.md` 的範例指令也假設 repo 在 `D:\code\dotfiles`。
- `windows/fix-textscale.ps1`：Modern Standby 喚醒後系統 UI 字型會掉回 100%，此腳本直接用 `SystemParametersInfoW` 改 NONCLIENTMETRICS / icon title 字型高度並寫回 `TextScaleFactor`；由 `install-fixtextscale.ps1` 建立的 `FixTextScale` 排程在喚醒 (Kernel-Power 507)、解鎖、登入時執行。
