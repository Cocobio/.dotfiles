# Windows side of the dotfiles: GlazeWM + PowerToys.
#
#   powershell -ExecutionPolicy Bypass -File windows.ps1
#
# UNTESTED. Written on the Linux laptop, never run on Windows. Read it before
# running it; every step prints what it is about to do.

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot   # ...\.dotfiles

function Say($m) { Write-Host "==> $m" -ForegroundColor Cyan }

# ---------------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------------
Say 'Installing packages via winget'
$pkgs = @(
    'glzr-io.glazewm',            # the window manager
    'Microsoft.PowerToys',        # keyboard remaps, launcher, FancyZones
    'Microsoft.WindowsTerminal'   # `wt`, what lwin+enter opens
)
foreach ($p in $pkgs) {
    winget install --id $p --exact --silent `
        --accept-source-agreements --accept-package-agreements
}

# ---------------------------------------------------------------------------
# 2. GlazeWM config
# ---------------------------------------------------------------------------
# GlazeWM v3 reads %USERPROFILE%\.glzr\glazewm\config.yaml (v2 used .glaze-wm).
# Copied rather than symlinked: symlinks on Windows need developer mode or an
# elevated shell, and this has to work from a normal prompt.
$glzrDir = Join-Path $env:USERPROFILE '.glzr\glazewm'
$src     = Join-Path $repo 'glazewm\glazewm_config.yaml'
$dst     = Join-Path $glzrDir 'config.yaml'

Say "Installing GlazeWM config -> $dst"
New-Item -ItemType Directory -Force -Path $glzrDir | Out-Null
if (Test-Path $dst) {
    $backup = "$dst.bak-$(Get-Date -Format yyyyMMddHHmmss)"
    Say "  existing config kept as $backup"
    Copy-Item $dst $backup
}
Copy-Item $src $dst -Force

# ---------------------------------------------------------------------------
# 3. Windows shortcut conflicts -- READ THIS BEFORE ENABLING
# ---------------------------------------------------------------------------
# The GlazeWM config binds lwin+<key> throughout, and Windows already owns many
# of those: lwin+arrows (Snap), lwin+1..9 (taskbar), lwin+a/c/e/g/r/s/w and
# lwin+enter. GlazeWM's low-level keyboard hook normally sees them first, so in
# practice most simply work.
#
# TEST GLAZEWM ON ITS OWN FIRST. Only if a specific chord fails is any of the
# below worth trying.
#
# PowerToys can map a shortcut to "Disable", which is virtual key code 256
# (PowerToys source: `const DWORD VK_DISABLED = 0x100;`). But Disable SWALLOWS
# the keystroke, and PowerToys and GlazeWM both use low-level hooks with no
# defined ordering between them -- so disabling a chord may stop GlazeWM
# receiving it as well, breaking the binding rather than freeing it. That is why
# nothing here is applied automatically.
#
# Codes: LWin 91, LShift 160, LCtrl 162, LAlt 164, Enter 13,
#        arrows 37/38/39/40 (L/U/R/D), digits 1-9 are 49-57, letters are ASCII.
#
# To try it, create ONE disable mapping in the PowerToys UI, inspect
#   %LOCALAPPDATA%\Microsoft\PowerToys\Keyboard Manager\default.json
# to confirm the encoding on your build, then extend it. Example shape:
#
#   {
#     "remapKeys":      { "inProcess": [] },
#     "remapShortcuts": {
#       "global": [ { "originalKeys": "91;83", "newRemapKeys": "256" } ],
#       "appSpecific": []
#     }
#   }
#
# PowerToys must be restarted to pick up a hand-edited file.

# ---------------------------------------------------------------------------
# 4. PowerToys Run on Win+Space
# ---------------------------------------------------------------------------
# Matches the laptop, where SUPER+Space opens the fuzzel launcher. GlazeWM has
# no launcher of its own, so PowerToys Run fills that hole.
#
# Its default is Alt+Space -- PowerToys source: DefaultOpenPowerLauncher =>
# new HotkeySettings(false, false, true, false, 32), i.e. alt=true, code=32.
# Alt is exactly the space we are keeping clear for tmux in WSL, so it moves.
#
# The settings file only exists once PowerToys has run at least once, so this
# skips rather than inventing a file, which PowerToys would overwrite anyway.
$runSettings = Join-Path $env:LOCALAPPDATA 'Microsoft\PowerToys\PowerToys Run\settings.json'
if (Test-Path $runSettings) {
    Say 'Setting PowerToys Run hotkey to Win+Space'
    Copy-Item $runSettings "$runSettings.bak-$(Get-Date -Format yyyyMMddHHmmss)"
    $json = Get-Content $runSettings -Raw | ConvertFrom-Json
    if (-not $json.properties) {
        $json | Add-Member -NotePropertyName properties -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    $hotkey = [pscustomobject]@{ win = $true; ctrl = $false; alt = $false; shift = $false; code = 32; key = 'Space' }
    $json.properties | Add-Member -NotePropertyName open_powerlauncher -NotePropertyValue $hotkey -Force
    $json | ConvertTo-Json -Depth 20 | Set-Content $runSettings -Encoding utf8
    Say '  restart PowerToys for this to take effect'
} else {
    Say 'PowerToys Run settings not found -- launch PowerToys once, then re-run this script'
}

# NOTE: Windows uses Win+Space to switch keyboard layout. With a single layout
# installed that is harmless; with more than one, the shell may win and PowerToys
# Run will not open. PowerToys flags this itself as a system conflict in its
# settings UI. If it happens, either remove the extra layout or pick another
# chord here and in the GlazeWM config.

$kbmDir = Join-Path $env:LOCALAPPDATA 'Microsoft\PowerToys\Keyboard Manager'
if (Test-Path (Join-Path $kbmDir 'default.json')) {
    Say "PowerToys Keyboard Manager config found at $kbmDir (left untouched)"
} else {
    Say 'PowerToys Keyboard Manager has no config yet (nothing to conflict with)'
}

Say 'Done. Start GlazeWM and test the lwin bindings before changing anything else.'
