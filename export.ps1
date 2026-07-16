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
. (Join-Path $PSScriptRoot "worldlib.ps1")

Assert-MinecraftClosed

$roots = Resolve-WorldsRoots $WorldsPath
$src   = Find-WorldFolder $roots $WorldName
if (-not $src) { throw "Nie znalazlem swiata '$WorldName' - zagraj w niego raz albo zrob najpierw import." }

$out = Join-Path $PSScriptRoot "RychuP.mcworld"

# Compress-Archive akceptuje tylko rozszerzenie .zip - pakujemy do tymczasowego .zip,
# a dopiero potem podmieniamy na .mcworld. Stary plik kasujemy DOPIERO po udanym spakowaniu,
# zeby ewentualny blad nie zostawil repo bez swiata.
$tmp = "$out.zip"
if (Test-Path $tmp) { Remove-Item $tmp -Force }

# pakujemy ZAWARTOSC folderu (db\, level.dat, ...) do korzenia archiwum - tak wyglada .mcworld
Compress-Archive -Path (Join-Path $src "*") -DestinationPath $tmp -CompressionLevel Optimal

if (Test-Path $out) { Remove-Item $out -Force }
Move-Item $tmp $out -Force

$size = "{0:N1} MB" -f ((Get-Item $out).Length / 1MB)
Write-Host "OK. Zapisano $out ($size) ze swiata:" -ForegroundColor Green
Write-Host "  $src" -ForegroundColor DarkGray
Write-Host "Teraz: git add RychuP.mcworld; git commit -m 'Sesja ...'; git pull --no-rebase; git push" -ForegroundColor Yellow
