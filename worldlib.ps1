<#
  worldlib.ps1 - wspolne funkcje dla import.ps1 / export.ps1.
  Nie uruchamiaj tego pliku bezposrednio - jest dot-source'owany przez tamte skrypty.
#>

# Lista mozliwych folderow minecraftWorlds na tym komputerze (klient Bedrock).
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

# Sciezka do folderu swiata o nazwie $name (levelname.txt), albo $null.
function Find-WorldFolder($roots, $name) {
  foreach ($r in $roots) {
    if (-not (Test-Path $r)) { continue }
    foreach ($d in (Get-ChildItem $r -Directory -ErrorAction SilentlyContinue)) {
      $ln = Join-Path $d.FullName "levelname.txt"
      # "$(...)" chroni przed pustym plikiem (Get-Content -Raw zwraca wtedy $null)
      if ((Test-Path $ln) -and ("$(Get-Content $ln -Raw)".Trim() -ieq $name)) {
        return $d.FullName
      }
    }
  }
  return $null
}

# Zwraca liste rootow: podany -WorldsPath, albo auto-wykrycie.
function Resolve-WorldsRoots($worldsPath) {
  if ($worldsPath) { @($worldsPath) } else { Get-WorldsRoots }
}

# Przerywa, jesli klient Minecraft for Windows jest uruchomiony (blokuje pliki bazy).
function Assert-MinecraftClosed {
  if (Get-Process -Name "Minecraft.Windows" -ErrorAction SilentlyContinue) {
    throw "Minecraft jest uruchomiony - zamknij go i sprobuj ponownie."
  }
}
