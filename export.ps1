<#
  export.ps1 - pakuje swiat z serwera Bedrock z powrotem do RychuP.mcworld.
  Uruchom PO sesji, ZATRZYMAJ najpierw serwer (inaczej pliki db sa zablokowane).

  Przyklad:
    .\export.ps1 -ServerPath "C:\bedrock-server"
  Potem:  git add RychuP.mcworld; git commit -m "..."; git pull --no-rebase; git push
#>
param(
  [Parameter(Mandatory = $true)][string]$ServerPath,
  [string]$WorldName = "RychuP"
)
$ErrorActionPreference = "Stop"

$src = Join-Path $ServerPath "worlds\$WorldName"
if (-not (Test-Path $src)) { throw "Nie ma swiata: $src (sprawdz -WorldName)" }
if (Get-Process -Name "bedrock_server" -ErrorAction SilentlyContinue) {
  throw "bedrock_server dziala - zatrzymaj serwer przed eksportem (pliki db sa zablokowane)."
}

$out = Join-Path $PSScriptRoot "RychuP.mcworld"
if (Test-Path $out) { Remove-Item $out -Force }

# Pakujemy ZAWARTOSC folderu (db/, level.dat, ...) do korzenia archiwum - tak wyglada .mcworld
Compress-Archive -Path (Join-Path $src "*") -DestinationPath $out -CompressionLevel Optimal

$size = "{0:N1} MB" -f ((Get-Item $out).Length / 1MB)
Write-Host "OK. Zapisano $out ($size)." -ForegroundColor Green
Write-Host "Teraz: git add RychuP.mcworld; git commit -m 'Sesja ...'; git pull --no-rebase; git push" -ForegroundColor Yellow
