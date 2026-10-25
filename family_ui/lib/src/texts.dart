// Interface texts: each app brings its own, the family adds the ones every app needs.
import 'package:flutter/widgets.dart';

const languages = {'de': 'Deutsch', 'en': 'English'};

/// The device language if the apps speak it, otherwise [fallback].
String deviceLang(String fallback) {
  final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return languages.containsKey(code) ? code : fallback;
}

const _common = <String, Map<String, String>>{
  'de': {
    'settings': 'Einstellungen',
    'display': 'Darstellung',
    'language': 'Sprache',
    'theme': 'Design',
    'theme.system': 'System',
    'theme.light': 'Hell',
    'theme.dark': 'Dunkel',
    'save': 'Speichern',
    'cancel': 'Abbrechen',
    'undo': 'Rückgängig',
    'family.more': 'Mehr von uns',
    'family.soon': 'Bald verfügbar',
    'promise': 'Ohne Werbung, ohne Tracking, ohne Konto. Alles bleibt auf deinem Gerät und funktioniert offline.',
  },
  'en': {
    'settings': 'Settings',
    'display': 'Display',
    'language': 'Language',
    'theme': 'Theme',
    'theme.system': 'System',
    'theme.light': 'Light',
    'theme.dark': 'Dark',
    'save': 'Save',
    'cancel': 'Cancel',
    'undo': 'Undo',
    'family.more': 'More from us',
    'family.soon': 'Coming soon',
    'promise': 'No ads, no tracking, no account. Everything stays on your device and works offline.',
  },
};

/// An app's texts plus the family's common ones. The app's own text wins if both have a key.
class Texts {
  const Texts(this._app);

  final Map<String, Map<String, String>> _app;

  /// Text for [key] in [lang], English if missing, with {placeholders} filled from [vars].
  String call(String lang, String key, [Map<String, Object> vars = const {}]) {
    var s = _app[lang]?[key] ?? _common[lang]?[key] ?? _app['en']?[key] ?? _common['en']?[key] ?? key;
    vars.forEach((k, v) => s = s.replaceAll('{$k}', '$v'));
    return s;
  }
}

/// The family's common texts, for shared widgets.
const familyTexts = Texts({});
