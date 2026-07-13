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

Gramy w kliencie **Minecraft for Windows (Bedrock)**. Świat siedzi w archiwum
`.mcworld`, a skrypty `import.ps1` / `export.ps1` **same znajdują świat po nazwie**
w zapisach gry (`levelname.txt == RychuP`) — nie trzeba niczego konfigurować.

> ⚠️ **Zamknij Minecrafta** przed uruchomieniem któregokolwiek skryptu — inaczej
> pliki świata są zablokowane. Skrypty to sprawdzają i przerwą, jeśli gra działa.

## Jak zacząć grać (pobranie najnowszej wersji)

```powershell
# raz, przy pierwszym pobraniu:
git lfs install
git clone https://github.com/dawidzebacki/MC-world.git
cd MC-world

# kolejne razy — tylko odśwież:
git pull

# wgraj świat do gry (Minecraft musi być zamknięty):
.\import.ps1
```

Potem odpal Minecrafta — świat **RychuP** będzie na liście. Przy pierwszym imporcie
skrypt tworzy nowy świat; przy kolejnych podmienia istniejący, a jego poprzednią
wersję odkłada do `.world-backup\` (poza folderem gry, żeby nie robić duplikatu).

## Po sesji (wrzucenie nowej wersji)

**Najpierw zamknij Minecrafta**, potem:

```powershell
.\export.ps1            # pakuje świat z gry do RychuP.mcworld
git add RychuP.mcworld
git commit -m "Sesja <twoje imię> <data> — co się wydarzyło"
git pull --no-rebase    # dociągnij, gdyby ktoś coś wrzucił w międzyczasie
git push
```

Jeśli `git push` odrzuci zmiany — znaczy, że ktoś wrzucił nowszą wersję.
**Nie nadpisuj na siłę** — dogadajcie się, czyja sesja jest ważniejsza.

> Jeśli Windows blokuje uruchomienie skryptu, odpal go tak:
> `powershell -ExecutionPolicy Bypass -File .\import.ps1`
>
> Gdyby skrypt nie znalazł świata (nietypowa instalacja), podaj folder ręcznie:
> `.\import.ps1 -WorldsPath "...\com.mojang\minecraftWorlds"`
