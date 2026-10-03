# 建立排程 FixTextScale：在睡眠喚醒、解鎖、登入時執行 windows\fix-textscale.ps1，
# 把 Text size 重新套用回來 (Modern Standby 喚醒後系統 UI 字型會掉回 100%)。
# 排程以目前使用者身分執行，不需要管理員權限。
#
# 用法 (公司電腦若擋腳本執行，用 -ExecutionPolicy Bypass 只對這次生效)：
#   powershell -ExecutionPolicy Bypass -File .\install-fixtextscale.ps1
#   powershell -ExecutionPolicy Bypass -File .\install-fixtextscale.ps1 -Scale 150
#   powershell -ExecutionPolicy Bypass -File .\install-fixtextscale.ps1 -Uninstall
#
# 注意：此檔存成 UTF-8 with BOM，Windows PowerShell 5.1 才不會把中文當成 cp950 讀壞。

param(
  [int]$Scale = 125,   # 要維持的 Text size (%)
  [switch]$Uninstall   # 移除排程
)

$ErrorActionPreference = "Stop"

$taskName = "FixTextScale"

if ($Uninstall) {
  if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "已移除排程 $taskName"
  } else {
    Write-Host "排程 $taskName 不存在"
  }
  return
}

$script = Join-Path $PSScriptRoot "windows\fix-textscale.ps1"
if (-not (Test-Path $script)) {
  throw "找不到 $script，請在 dotfiles repo 根目錄執行此腳本"
}

$user = "$env:USERDOMAIN\$env:USERNAME"
$escapedScript = [Security.SecurityElement]::Escape($script)

# 觸發條件：
#   - Kernel-Power 507：離開 Modern Standby (延遲 5 秒，等桌面就緒)
#   - 解鎖、登入
# 用 conhost --headless 執行，才不會閃出 PowerShell 視窗。
$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo><Description>Re-apply Text size $Scale% after Modern Standby wake / unlock / logon ($escapedScript)</Description></RegistrationInfo>
  <Triggers>
    <EventTrigger>
      <Enabled>true</Enabled>
      <Subscription>&lt;QueryList&gt;&lt;Query Id="0" Path="System"&gt;&lt;Select Path="System"&gt;*[System[Provider[@Name='Microsoft-Windows-Kernel-Power'] and EventID=507]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription>
      <Delay>PT5S</Delay>
    </EventTrigger>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled>
      <StateChange>SessionUnlock</StateChange>
      <UserId>$user</UserId>
      <Delay>PT2S</Delay>
    </SessionStateChangeTrigger>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>$user</UserId>
      <Delay>PT10S</Delay>
    </LogonTrigger>
  </Triggers>
  <Principals><Principal id="Author"><UserId>$user</UserId><LogonType>InteractiveToken</LogonType><RunLevel>LeastPrivilege</RunLevel></Principal></Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <ExecutionTimeLimit>PT1M</ExecutionTimeLimit>
    <Enabled>true</Enabled>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>conhost.exe</Command>
      <Arguments>--headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$escapedScript" -Scale $Scale</Arguments>
    </Exec>
  </Actions>
</Task>
"@

Register-ScheduledTask -TaskName $taskName -Xml $xml -Force | Out-Null
Write-Host "已建立排程 $taskName (Text size $Scale%)：$script"

# 先跑一次，立刻套用
Start-ScheduledTask -TaskName $taskName
Write-Host "完成"
