# MC-world 🌍

Wspólny świat Minecrafta (Bedrock, `.mcworld`) do gry na zmianę ze znajomymi.

Zasada jest prosta — **podajemy sobie save'a z rąk do rąk**:
1. Kto chce grać, **pobiera najnowszą wersję** z repo.
2. Gra swoją sesję.
3. Po skończeniu **wrzuca nowy plik** z powrotem tutaj.

> ⚠️ **Gra jedna osoba naraz!** Nie ma automatycznego łączenia świata — jak dwie
> osoby zagrają równolegle, jedna wersja nadpisze drugą. Umawiajcie się kto ma "turę".

Plik `.mcworld` jest trzymany przez **Git LFS** (to duży plik binarny), więc
przed pierwszym użyciem zainstaluj LFS: <https://git-lfs.com>

---

Gramy na **dedykowanym serwerze Bedrock** (`bedrock_server.exe`). Świat siedzi
w archiwum `.mcworld`, a skrypty `import.ps1` / `export.ps1` rozpakowują go do
`worlds/` serwera i pakują z powrotem. W `server.properties` musisz mieć
`level-name=RychuP`.

## Jak zacząć grać (pobranie najnowszej wersji)

```powershell
# raz, przy pierwszym pobraniu:
git lfs install
git clone https://github.com/dawidzebacki/MC-world.git
cd MC-world

# kolejne razy — tylko odśwież:
git pull

# rozpakuj świat do serwera (podaj ścieżkę do folderu z bedrock_server.exe):
.\import.ps1 -ServerPath "C:\bedrock-server"
```

Potem odpal `bedrock_server.exe` i graj. Skrypt robi kopię poprzedniego świata
na serwerze jako `worlds\RychuP.bak`, więc nic nie zginie.

## Po sesji (wrzucenie nowej wersji)

**Najpierw zatrzymaj serwer** (inaczej pliki bazy są zablokowane), potem:

```powershell
.\export.ps1 -ServerPath "C:\bedrock-server"    # pakuje świat z serwera do RychuP.mcworld
git add RychuP.mcworld
git commit -m "Sesja <twoje imię> <data> — co się wydarzyło"
git pull --no-rebase     # dociągnij, gdyby ktoś coś wrzucił w międzyczasie
git push
```

Jeśli `git push` odrzuci zmiany — znaczy, że ktoś wrzucił nowszą wersję.
**Nie nadpisuj na siłę** — dogadajcie się, czyja sesja jest ważniejsza.

> Jeśli Windows blokuje uruchomienie skryptu, odpal go tak:
> `powershell -ExecutionPolicy Bypass -File .\import.ps1 -ServerPath "C:\bedrock-server"`
