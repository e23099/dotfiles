# setting up new environment.


## For windows wezterm

wezterm 啟動時讀取 `%USERPROFILE%\.wezterm.lua`。
用 symlink 把它指到這個 repo 的檔案，改 repo 就即時生效 (需要開發者模式或系統管理員權限)：

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wezterm.lua" -Target "D:\code\dotfiles\wezterm\wezterm.lua"
```

設定重點：字型 `FiraCode Nerd Font Mono`、配色 `catppuccin-macchiato`、預設開 powershell 於 `D:/Work`。

### 常用按鍵

| 按鍵 | 功能 |
|---|---|
| `Alt+1` ~ `Alt+9` | 切換到第 1 ~ 9 個 tab |
| `Alt+Shift+%` | 水平分割 pane |
| `Alt+Shift+"` | 垂直分割 pane |
| `Ctrl+h/j/k/l` | 在 pane 之間移動焦點 (前景是 nvim 時會放行給 nvim 切 split) |


## For windows nvim

nvim 的設定目錄在 `:echo stdpath('config')`，通常是 `%LOCALAPPDATA%\nvim`。
用 junction 把它指到這個 repo 的 nvim 資料夾，改 repo 就即時生效 (不需要管理員權限)：

```powershell
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "D:\code\dotfiles\nvim"
```

第一次啟動 nvim 會自動下載 lazy.nvim 和兩個外掛，需要網路。

### 常用按鍵 (leader = 空白鍵)

| 按鍵 | 功能 |
|---|---|
| `<leader>big` | 以 cp950 (Big5) 重新讀取目前檔案 |
| `<leader>utf` | 以 utf-8 重新讀取目前檔案 |
| `<leader>log` | 把目前 buffer 當作 log 上色 (副檔名不是 .log 時用) |

開檔時會自動依 utf-8 → cp950 順序偵測編碼，狀態列中間會顯示目前用的編碼。
