<#
  import.ps1 - wgrywa RychuP.mcworld do zapisow klienta Minecraft for Windows (Bedrock).
  Uruchom PRZED graniem (po 'git pull'). ZAMKNIJ najpierw Minecrafta.

  Skrypt sam znajduje swiat po nazwie (levelname.txt == RychuP). Jesli nie ma go
  jeszcze na tym komputerze - tworzy nowy. Poprzednia wersja swiata laduje do
  .world-backup\ (poza folderem gry, zeby nie robic duplikatu w menu).

  Uzycie:   .\import.ps1
  Opcje:    -WorldName "RychuP"   -WorldsPath "sciezka\do\minecraftWorlds"
#>
param(
  [string]$WorldName = "RychuP",
  [string]$WorldsPath = ""
)
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "worldlib.ps1")

$mcworld = Join-Path $PSScriptRoot "RychuP.mcworld"
if (-not (Test-Path $mcworld)) { throw "Nie ma $mcworld - zrob najpierw 'git pull'." }
Assert-MinecraftClosed

$roots = Resolve-WorldsRoots $WorldsPath

# Rozpakuj nowa wersje do staging. Gdyby padlo (uszkodzony plik, brak miejsca) -
# stary swiat na dysku pozostaje nietkniety, bo podmieniamy dopiero po sukcesie.
$staging = Join-Path $PSScriptRoot ".world-staging"
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory $staging -Force | Out-Null
Expand-Archive -Path $mcworld -DestinationPath $staging -Force

$dest = Find-WorldFolder $roots $WorldName
if ($dest) {
  # backup starego swiata POZA minecraftWorlds (inaczej gra pokazalaby duplikat)
  $bak = Join-Path $PSScriptRoot ".world-backup\$WorldName"
  if (Test-Path $bak) { Remove-Item $bak -Recurse -Force }
  New-Item -ItemType Directory (Split-Path $bak) -Force | Out-Null
  Move-Item $dest $bak
  Write-Host "Poprzedni swiat odlozony do: $bak" -ForegroundColor DarkGray
} else {
  # nowy swiat: wybierz root, ktory juz zawiera swiaty (to ten, ktorego uzywa gra)
  $root = $roots | Where-Object { Test-Path $_ } |
    Sort-Object { @(Get-ChildItem $_ -Directory -ErrorAction SilentlyContinue).Count } -Descending |
    Select-Object -First 1
  if (-not $root) { $root = $roots | Select-Object -First 1 }
  if (-not $root) { throw "Nie znalazlem folderu minecraftWorlds - podaj recznie -WorldsPath." }
  New-Item -ItemType Directory $root -Force | Out-Null
  $dest = Join-Path $root $WorldName
  Write-Host "Tworze nowy swiat: $dest" -ForegroundColor DarkGray
}

Move-Item $staging $dest
Write-Host "OK. Swiat '$WorldName' wgrany. Odpal Minecrafta i graj." -ForegroundColor Green
