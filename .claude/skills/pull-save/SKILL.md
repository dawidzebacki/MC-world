---
name: pull-save
description: Ściągnij najnowszą wersję świata z GitHuba i wgraj ją do gry przed sesją. Użyj gdy user chce pobrać / wgrać / zaimportować świat ("ściągnij save", "wgraj świat", "pull the save", "pobierz najnowszą wersję", "chcę zagrać").
---

# Pull save świata z GitHuba

Workflow PRZED sesją: dociągnij najnowszy `RychuP.mcworld` z `main` i wgraj go do
klienta Minecraft for Windows. Odwrotność [push-save]. **Gra jedna osoba naraz** —
upewnij się, że nikt inny nie ma właśnie "tury".

## Kroki

1. **Sprawdź, czy Minecraft jest zamknięty.** Pliki świata są zablokowane, gdy gra
   działa. `import.ps1` sam to weryfikuje i przerwie, ale sprawdź wcześniej:
   ```powershell
   if (Get-Process -Name "Minecraft.Windows" -ErrorAction SilentlyContinue) { "DZIALA - popros usera o zamkniecie" } else { "ok" }
   ```
   Jeśli działa — poproś usera, żeby zamknął grę, zanim ruszysz dalej.

2. **Dociągnij najnowszą wersję** (LFS ściągnie duży plik `.mcworld`):
   ```bash
   git pull
   ```
   Jeśli masz lokalne, niezacommitowane zmiany świata (`git status` pokazuje
   `RychuP.mcworld`) — **STOP**. Znaczy, że ktoś (może user) ma niewypchniętą sesję.
   Nie nadpisuj — zapytaj usera, czy najpierw zrobimy [push-save].

3. **Wgraj świat do gry:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\import.ps1
   ```
   Skrypt rozpakowuje `.mcworld` do `.world-staging`, a dopiero po sukcesie podmienia
   świat w grze (przy błędzie stary świat zostaje nietknięty). Jeśli świat już istnieje
   na tym kompie, jego poprzednia wersja ląduje w `.world-backup\` (poza folderem gry,
   żeby nie robić duplikatu w menu). Jeśli świata nie ma — tworzy nowy.

4. **Potwierdź userowi:** świat wgrany, może odpalać Minecrafta — **RychuP** będzie
   na liście światów.

## Gotchas

- **Pierwszy raz na tym kompie** → user musi mieć zainstalowany Git LFS
  (`git lfs install`, <https://git-lfs.com>), inaczej `.mcworld` ściągnie się jako
  tekstowy wskaźnik LFS zamiast właściwego pliku (kilkaset bajtów zamiast ~100 MB).
  Jeśli `import.ps1` wywali się na "uszkodzonym" archiwum — sprawdź rozmiar
  `RychuP.mcworld`; jeśli malutki, to brak LFS.
- **Lokalne zmiany świata przed `git pull`** → patrz krok 2, nie nadpisuj cudzej
  sesji. Najpierw [push-save] albo dogadanie się z ekipą.
- **Nietypowa instalacja gry** → jeśli skrypt nie znajdzie folderu światów, podaj
  ręcznie: `.\import.ps1 -WorldsPath "...\com.mojang\minecraftWorlds"`.
- **Backup** → poprzednia lokalna wersja świata siedzi w `.world-backup\RychuP`
  (gitignorowana). Gdyby import coś zepsuł, można z niej odtworzyć ręcznie.
