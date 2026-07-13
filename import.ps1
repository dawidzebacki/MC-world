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

function Get-WorldsRoots {
  $roots = @()
  if ($env:LOCALAPPDATA) {
    $roots += Join-Path $env:LOCALAPPDATA "Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds"
  }
  if ($env:APPDATA) {
    $base = Join-Path $env:APPDATA "Minecraft Bedrock\Users"
    if (Test-Path $base) {
      Get-ChildItem $base -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $roots += Join-Path $_.FullName "games\com.mojang\minecraftWorlds"
      }
    }
  }
  $roots | Where-Object { $_ } | Select-Object -Unique
}

function Find-WorldFolder($roots, $name) {
  foreach ($r in $roots) {
    if (-not (Test-Path $r)) { continue }
    foreach ($d in (Get-ChildItem $r -Directory -ErrorAction SilentlyContinue)) {
      $ln = Join-Path $d.FullName "levelname.txt"
      if (Test-Path $ln) {
        if (((Get-Content $ln -Raw).Trim()) -ieq $name) { return $d.FullName }
      }
    }
  }
  return $null
}

$mcworld = Join-Path $PSScriptRoot "RychuP.mcworld"
if (-not (Test-Path $mcworld)) { throw "Nie ma $mcworld - zrob najpierw 'git pull'." }
if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "Minecraft*" }) {
  throw "Minecraft jest uruchomiony - zamknij go przed importem."
}

$roots = if ($WorldsPath) { @($WorldsPath) } else { Get-WorldsRoots }
$dest  = Find-WorldFolder $roots $WorldName

if ($dest) {
  # backup poza minecraftWorlds, potem czyste rozpakowanie w to samo miejsce
  $bak = Join-Path $PSScriptRoot ".world-backup\$WorldName"
  if (Test-Path $bak) { Remove-Item $bak -Recurse -Force }
  New-Item -ItemType Directory (Split-Path $bak) -Force | Out-Null
  Move-Item $dest $bak
  New-Item -ItemType Directory $dest -Force | Out-Null
  Write-Host "Poprzedni swiat odlozony do: $bak" -ForegroundColor DarkGray
} else {
  $root = $roots | Where-Object { Test-Path $_ } | Select-Object -First 1
  if (-not $root) { $root = $roots | Select-Object -First 1 }
  if (-not $root) { throw "Nie znalazlem folderu minecraftWorlds - podaj recznie -WorldsPath." }
  New-Item -ItemType Directory $root -Force | Out-Null
  $dest = Join-Path $root $WorldName
  New-Item -ItemType Directory $dest -Force | Out-Null
  Write-Host "Tworze nowy swiat: $dest" -ForegroundColor DarkGray
}

Expand-Archive -Path $mcworld -DestinationPath $dest -Force
Write-Host "OK. Swiat '$WorldName' wgrany. Odpal Minecrafta i graj." -ForegroundColor Green
