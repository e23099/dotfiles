# 在 Windows 上把 %LOCALAPPDATA%\nvim 用 junction 指到這個 repo 的 nvim 資料夾，
# 然後用 lazy-lock.json 裝好外掛。junction 不需要管理員權限或開發者模式。
#
# 用法 (公司電腦若擋腳本執行，用 -ExecutionPolicy Bypass 只對這次生效)：
#   powershell -ExecutionPolicy Bypass -File .\install-nvim.ps1
#   powershell -ExecutionPolicy Bypass -File .\install-nvim.ps1 -SkipPlugins
#
# 注意：此檔存成 UTF-8 with BOM，Windows PowerShell 5.1 才不會把中文當成 cp950 讀壞。

param(
  [switch]$SkipPlugins # 只建 junction，不跑 Lazy restore (例如沒網路時)
)

$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "nvim"
$target = Join-Path $env:LOCALAPPDATA "nvim"

if (-not (Test-Path $source)) {
  throw "找不到 $source，請在 dotfiles repo 根目錄執行此腳本"
}

# 檢查必要工具：git 給 lazy.nvim 下載外掛用
foreach ($cmd in "nvim", "git") {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Write-Warning "找不到 $cmd，請先安裝並加入 PATH"
  }
}

# 建立 junction；已存在的東西先備份，不直接刪
$item = Get-Item $target -Force -ErrorAction SilentlyContinue
if ($item -and $item.LinkType -eq "Junction" -and
    ((Resolve-Path $item.Target[0]).Path -eq (Resolve-Path $source).Path)) {
  Write-Host "junction 已存在：$target -> $source"
} else {
  if ($item) {
    $backup = "$target.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
    if ($item.LinkType) {
      # 指向別處的 link：只移除 link 本身，不動它指向的內容
      Write-Host "移除舊的 $($item.LinkType)：$target -> $($item.Target)"
      $item.Delete()
    } else {
      Write-Host "備份既有設定：$target -> $backup"
      Move-Item $target $backup
    }
  }
  New-Item -ItemType Junction -Path $target -Target $source | Out-Null
  Write-Host "已建立 junction：$target -> $source"
}

# 依 lazy-lock.json 安裝外掛 (第一次會先 bootstrap lazy.nvim，需要網路)
if (-not $SkipPlugins -and (Get-Command nvim -ErrorAction SilentlyContinue)) {
  Write-Host "安裝外掛中 (Lazy restore)..."
  nvim --headless "+Lazy! restore" +qa
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "外掛安裝失敗，可能是網路/proxy 問題；之後開 nvim 執行 :Lazy restore 重試"
  } else {
    Write-Host "完成"
  }
}
