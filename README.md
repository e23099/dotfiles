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
