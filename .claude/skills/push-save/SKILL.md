---
name: push-save
description: Spakuj najświeższy świat Minecrafta z gry i wypchnij go na GitHub. Użyj gdy user chce wrzucić / wypchać / zapisać save po sesji ("wypchnij save", "wrzuć świat", "push the save", "zapisz sesję").
---

# Push save świata na GitHub

Workflow po sesji: spakuj świat z klienta Minecraft for Windows do `RychuP.mcworld`
(Git LFS) i wypchnij na `main`. **Gra jedna osoba naraz** — nie ma mergowania światów.

## Kroki

1. **Sprawdź, czy Minecraft jest zamknięty.** Pliki bazy świata są zablokowane, gdy
   gra działa. `export.ps1` sam to weryfikuje i przerwie, ale sprawdź wcześniej:
   ```powershell
   if (Get-Process -Name "Minecraft.Windows" -ErrorAction SilentlyContinue) { "DZIALA - popros usera o zamkniecie" } else { "ok" }
   ```
   Jeśli działa — poproś usera, żeby zamknął grę, zanim ruszysz dalej.

2. **Spakuj świat:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\export.ps1
   ```
   Skrypt sam znajduje świat po `levelname.txt == RychuP`, pakuje do tymczasowego
   `.zip` i podmienia na `RychuP.mcworld`. Stary plik kasuje dopiero po udanym
   spakowaniu (nie zostawi repo bez świata przy błędzie).

3. **Sprawdź, że LFS łapie plik** (powinien pokazać `RychuP.mcworld` jako LFS):
   ```bash
   git lfs status
   ```

4. **Commit + pull + push.** W commit message: `Sesja <imię> <YYYY-MM-DD>`:
   ```bash
   git add RychuP.mcworld
   git commit -m "Sesja Dawid 2026-07-16"
   git pull --no-rebase
   git push
   ```

5. **Potwierdź userowi:** rozmiar spakowanego świata, hash commita, że push i upload
   LFS przeszły.

## Gotchas

- **Push odrzucony** → ktoś wrzucił nowszą wersję w międzyczasie. **NIE forsuj**
  (`--force`). Powiedz userowi — muszą dogadać czyja sesja jest ważniejsza.
- **`git pull --no-rebase`** (nie rebase) — plik binarny, konflikty rozstrzyga się
  ręcznie, nie przez przepisywanie historii.
- **`Compress-Archive` przyjmuje tylko `.zip`** — dlatego `export.ps1` pakuje przez
  temp `.zip` i zmienia nazwę. Nie "upraszczaj" tego z powrotem do zapisu prosto
  do `.mcworld` — wysypie się na niektórych wersjach PowerShella.
- **Nietypowa instalacja gry** → jeśli skrypt nie znajdzie świata, podaj folder
  ręcznie: `.\export.ps1 -WorldsPath "...\com.mojang\minecraftWorlds"`.
- **Weryfikacja przed commitem** (opcjonalnie) — świat rośnie z czasem; jeśli nowy
  `RychuP.mcworld` jest wyraźnie mniejszy niż w repo, to sygnał ostrzegawczy
  (może spakował się zły/pusty świat). Sprawdź, zanim wypchniesz.
