# Family kit

Shared code for **Sakina**, **Zaki**, **Majlis**, **Ease** and **Nūr**. Each app keeps its own colour, layout and character. What users see in common (shapes, type, the gold accent and the Arabic wordmark) and what they don't see (reminders, texts, animations) lives here, so a fix in one place reaches every app.

| Package | What's in it | Used by |
|---|---|---|
| `family_ui` | Theme, wordmark, shared widgets, language and theme pickers, "More from us", animations, texts | Sakina, Zaki, Majlis |
| `family_reminders` | Time zone setup, notification permission, scheduling | Sakina, Zaki, Ease, Nūr |

Reminders are a separate package so apps without reminders (Majlis) don't pull in the notification plugin.

## The family look

- **Each app's own colour** builds its theme: Sakina calm teal, Zaki deep green, Majlis night indigo.
- **Gold** (`familyGold`) for the Arabic name and small highlights; darker in light mode so it stays readable.
- **The wordmark** (`AppWordmark`): the Latin name, then the Arabic name in gold, e.g. *Zaki · زكي*.
- **Same shapes everywhere:** 20 px cards, 16 px buttons, 28 px dialogs and sheets, floating snackbars.
- **Motion** (`PopIn`, `Confetti`, `Shake`, `NightSky`, `CountUp`) always respects the system's "reduce motion" setting.

## Using it in an app

From GitHub (how the published apps build):

```yaml
dependencies:
  family_ui:
    git:
      url: https://github.com/darian7b7/family_kit.git
      path: family_ui
  family_reminders: # only with reminders
    git:
      url: https://github.com/darian7b7/family_kit.git
      path: family_reminders
```

While working on the kit itself, keep it next to the apps (`~/family_kit`, `~/sakina`, …) and put a `pubspec_overrides.yaml` (not committed) in the app, so changes show up at once:

```yaml
dependency_overrides:
  family_ui:
    path: ../family_kit/family_ui
  family_reminders:
    path: ../family_kit/family_reminders
```

```dart
theme: familyTheme(FamilyApps.zaki, Brightness.light),
appBar: AppBar(title: const AppWordmark(FamilyApps.zaki)),
// in settings:
MoreFromUs(current: FamilyApps.zaki, lang: lang, onOpen: (url) => launchUrl(Uri.parse(url))),
```

Texts: each app passes its own table to `Texts`. Common words (Settings, Language, Theme, Save, Cancel, Undo, …) come from the family, and the app's own text wins if both have one.

## Adding a store link

Fill in `url` for the app in `family_ui/lib/src/apps.dart`. "More from us" then opens it in every app instead of showing "Coming soon".

## Tests

```bash
cd family_ui && flutter test
```

## License

[MIT](LICENSE)
