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

## Jak zacząć grać (pobranie najnowszej wersji)

```bash
# raz, przy pierwszym pobraniu:
git lfs install
git clone https://github.com/dawidzebacki/MC-world.git
cd MC-world

# kolejne razy — tylko odśwież:
git pull
```

Zaimportuj `RychuP.mcworld` w Minecrafcie (dwuklik na plik lub *Ustawienia →
Magazyn → Importuj*) i graj.

## Po sesji (wrzucenie nowej wersji)

Wyeksportuj świat z Minecrafta jako `RychuP.mcworld`, podmień plik w tym folderze, a potem:

```bash
git add RychuP.mcworld
git commit -m "Sesja <twoje imię> <data> — co się wydarzyło"
git pull --no-rebase     # dociągnij, gdyby ktoś coś wrzucił w międzyczasie
git push
```

Jeśli `git push` odrzuci zmiany — znaczy, że ktoś wrzucił nowszą wersję.
**Nie nadpisuj na siłę** — dogadajcie się, czyja sesja jest ważniejsza.
