# dotfiles

nvim / wezterm / tmux 設定。

## Windows：設定 nvim

```powershell
git clone https://github.com/e23099/dotfiles.git
cd dotfiles
powershell -ExecutionPolicy Bypass -File .\install-nvim.ps1
```

腳本會把 `%LOCALAPPDATA%\nvim` 用 junction 指到 repo 的 `nvim` 資料夾 (不需要管理員權限；既有設定會先備份成 `nvim.bak-<時間>`)，再依 `lazy-lock.json` 裝好外掛。沒網路時加 `-SkipPlugins` 只建 junction。

需要先裝好 `nvim` 和 `git`。其他設定 (wezterm、按鍵說明) 見 [setup.md](setup.md)。

## Windows：睡眠喚醒後維持 Text size 125%

```powershell
powershell -ExecutionPolicy Bypass -File .\install-fixtextscale.ps1
```

Modern Standby 喚醒後，系統 UI 字型 (標題列、選單、對話框、圖示文字) 會掉回 100%，但 Text size 設定值還是 125，要在設定裡改成 126 才會重新套用。腳本建立排程 `FixTextScale`，在喚醒、解鎖、登入時執行 `windows\fix-textscale.ps1` 把字型設回去。其他大小用 `-Scale 150`，移除用 `-Uninstall`。
