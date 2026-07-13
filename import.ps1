<#
  import.ps1 - rozpakowuje RychuP.mcworld do folderu worlds/ serwera Bedrock.
  Uruchom PRZED graniem (po git pull).

  Przyklad:
    .\import.ps1 -ServerPath "C:\bedrock-server"
#>
param(
  # Sciezka do folderu z bedrock_server.exe
  [Parameter(Mandatory = $true)][string]$ServerPath,
  # Nazwa folderu swiata w worlds/ (musi sie zgadzac z level-name w server.properties)
  [string]$WorldName = "RychuP"
)
$ErrorActionPreference = "Stop"

$mcworld = Join-Path $PSScriptRoot "RychuP.mcworld"
if (-not (Test-Path $mcworld)) { throw "Nie znaleziono $mcworld - zrob najpierw 'git pull'." }
if (-not (Test-Path $ServerPath)) { throw "Nie ma folderu serwera: $ServerPath" }

$dest = Join-Path $ServerPath "worlds\$WorldName"

# Kopia zapasowa poprzedniego swiata na serwerze (na wszelki wypadek)
if (Test-Path $dest) {
  $backup = "$dest.bak"
  if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
  Rename-Item $dest $backup
  Write-Host "Poprzedni swiat odlozony do: $backup" -ForegroundColor DarkGray
}

New-Item -ItemType Directory -Path $dest -Force | Out-Null
Expand-Archive -Path $mcworld -DestinationPath $dest -Force

Write-Host "OK. Swiat rozpakowany do: $dest" -ForegroundColor Green
Write-Host "Upewnij sie, ze w server.properties masz: level-name=$WorldName" -ForegroundColor Yellow
