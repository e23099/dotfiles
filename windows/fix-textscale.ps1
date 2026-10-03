# Re-apply Windows "Text size" (Accessibility > Text size).
# After Modern Standby wake, TextScaleFactor in the registry stays correct but
# the system UI fonts (caption/menu/status/message/icon) fall back to 100%
# (lfHeight -12 instead of -15 at 96 DPI). Settings fixes it only when the
# value changes (125 -> 126), so we set the fonts directly.
param(
    [int]$Scale = 125
)

Add-Type -Namespace Win32 -Name Native -MemberDefinition @'
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SystemParametersInfoW(uint uiAction, uint uiParam,
    IntPtr pvParam, uint fWinIni);

[DllImport("user32.dll")]
public static extern uint GetDpiForSystem();
'@

$SPI_GETICONTITLELOGFONT = 0x1F
$SPI_SETICONTITLELOGFONT = 0x22
$SPI_GETNONCLIENTMETRICS = 0x29
$SPI_SETNONCLIENTMETRICS = 0x2A
$SPIF_UPDATE_AND_SEND = 0x3   # SPIF_UPDATEINIFILE | SPIF_SENDCHANGE

$NCM_SIZE = 504               # sizeof(NONCLIENTMETRICSW)
$LOGFONT_SIZE = 92            # sizeof(LOGFONTW)
# lfHeight offsets of lfCaptionFont, lfSmCaptionFont, lfMenuFont, lfStatusFont, lfMessageFont
$NCM_FONT_OFFSETS = 24, 124, 224, 316, 408

# Default UI font is 9pt; lfHeight = -(9pt in px) * scale.
$dpi = [Win32.Native]::GetDpiForSystem()
$lfHeight = -[int][Math]::Round(9 * $dpi / 72 * $Scale / 100)

$M = [Runtime.InteropServices.Marshal]

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Accessibility' `
    -Name TextScaleFactor -Value $Scale -Type DWord

$ncm = $M::AllocHGlobal($NCM_SIZE)
try {
    $M::WriteInt32($ncm, 0, $NCM_SIZE)
    if (-not [Win32.Native]::SystemParametersInfoW($SPI_GETNONCLIENTMETRICS, $NCM_SIZE, $ncm, 0)) {
        throw "SPI_GETNONCLIENTMETRICS failed"
    }
    $changed = $false
    foreach ($off in $NCM_FONT_OFFSETS) {
        if ($M::ReadInt32($ncm, $off) -ne $lfHeight) {
            $M::WriteInt32($ncm, $off, $lfHeight)
            $changed = $true
        }
    }
    if ($changed) {
        [void][Win32.Native]::SystemParametersInfoW($SPI_SETNONCLIENTMETRICS, $NCM_SIZE, $ncm, $SPIF_UPDATE_AND_SEND)
    }
} finally {
    $M::FreeHGlobal($ncm)
}

$lf = $M::AllocHGlobal($LOGFONT_SIZE)
try {
    if ([Win32.Native]::SystemParametersInfoW($SPI_GETICONTITLELOGFONT, $LOGFONT_SIZE, $lf, 0) -and
        $M::ReadInt32($lf, 0) -ne $lfHeight) {
        $M::WriteInt32($lf, 0, $lfHeight)
        [void][Win32.Native]::SystemParametersInfoW($SPI_SETICONTITLELOGFONT, $LOGFONT_SIZE, $lf, $SPIF_UPDATE_AND_SEND)
    }
} finally {
    $M::FreeHGlobal($lf)
}
