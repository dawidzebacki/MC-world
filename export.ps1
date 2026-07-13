<#
  export.ps1 - pakuje swiat RychuP z zapisow klienta Minecraft for Windows do RychuP.mcworld.
  Uruchom PO sesji. ZAMKNIJ najpierw Minecrafta (pliki bazy sa wtedy zablokowane).

  Skrypt sam znajduje swiat po nazwie (levelname.txt == RychuP).

  Uzycie:   .\export.ps1
  Opcje:    -WorldName "RychuP"   -WorldsPath "sciezka\do\minecraftWorlds"
  Potem:    git add RychuP.mcworld; git commit -m "..."; git pull --no-rebase; git push
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

if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "Minecraft*" }) {
  throw "Minecraft jest uruchomiony - zamknij go przed eksportem (pliki bazy sa zablokowane)."
}

$roots = if ($WorldsPath) { @($WorldsPath) } else { Get-WorldsRoots }
$src   = Find-WorldFolder $roots $WorldName
if (-not $src) { throw "Nie znalazlem swiata '$WorldName' - zagraj w niego raz albo zrob najpierw import." }

$out = Join-Path $PSScriptRoot "RychuP.mcworld"
if (Test-Path $out) { Remove-Item $out -Force }

# pakujemy ZAWARTOSC folderu (db\, level.dat, ...) do korzenia archiwum - tak wyglada .mcworld
Compress-Archive -Path (Join-Path $src "*") -DestinationPath $out -CompressionLevel Optimal

$size = "{0:N1} MB" -f ((Get-Item $out).Length / 1MB)
Write-Host "OK. Zapisano $out ($size) ze swiata:" -ForegroundColor Green
Write-Host "  $src" -ForegroundColor DarkGray
Write-Host "Teraz: git add RychuP.mcworld; git commit -m 'Sesja ...'; git pull --no-rebase; git push" -ForegroundColor Yellow
