# Aniki ReMake theme packaging script
# Run from the repo root: .\build.ps1
#
# A theme has no code to compile — it's just XAML/YAML files — so this doesn't
# "build" anything in the usual sense. It packages the Source folder into a .pthm
# file (Playnite's theme package format, same idea as a .pext for extensions), so
# you install it the same way every time via Playnite -> Add-ons -> Install add-on
# from file, instead of hunting down Playnite's Themes folder and copying files by
# hand.

$ErrorActionPreference = "Stop"

$sourceDir = "$PSScriptRoot\Source"
$themeYamlPath = "$sourceDir\theme.yaml"

if (-not (Test-Path $themeYamlPath)) {
    Write-Host "theme.yaml not found at $themeYamlPath" -ForegroundColor Red
    exit 1
}

$themeYaml = Get-Content $themeYamlPath -Raw
$themeName = [regex]::Match($themeYaml, '(?m)^Name:\s*(.+)$').Groups[1].Value.Trim()
$themeVersion = [regex]::Match($themeYaml, '(?m)^Version:\s*(.+)$').Groups[1].Value.Trim()

if ([string]::IsNullOrWhiteSpace($themeName)) {
    Write-Host "Couldn't read Name from theme.yaml." -ForegroundColor Red
    exit 1
}

Write-Host "Packaging '$themeName' v$themeVersion..."

$pthm = "$PSScriptRoot\$themeName.pthm"
if (Test-Path $pthm) { Remove-Item $pthm -Force }

Compress-Archive -Path "$sourceDir\*" -DestinationPath "$pthm.zip" -Force
Move-Item "$pthm.zip" $pthm -Force

Write-Host "Created $pthm — install it via Playnite -> Add-ons -> Install add-on from file." -ForegroundColor Green
