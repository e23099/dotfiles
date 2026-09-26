# setting up new environment.


## change bash to fish

```
$ chsh -s /usr/bin/fish
```

## change directory color (for windows WSL)

1. go to ~/.config/fish
2. execute `dircolors --print-database >> .dircolors`
    this will output dircolors to a file called `.dircolors`
3. edit `config.fish`, add `eval (dircolors -c ~/.config/fish/.dircolors)`
    this will make fish use the `.dircolors` specified.
    we can now change colors setting in .dircolors file to change the
    directory color printed in fish shell.

## add alias, forexample, make `vi` equals to `nvim` in fish

It's just two lines of shell script. First we type:
```
alias vi "nvim"
```
to make vi equals "nvim" in current shell. Then we type:
```
funcsave vi
```
to write this alias vi to `~/.config/fish/funtions/vi.fish`,
so that each time we're in fish, this alias is already known by fish.


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
