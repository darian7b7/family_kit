import 'package:family_ui/family_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {Brightness brightness = Brightness.light}) => MaterialApp(
      theme: familyTheme(FamilyApps.sakina, brightness),
      home: Scaffold(body: ListView(children: [child])),
    );

void main() {
  test('app texts win over the family ones; English and the key are fallbacks', () {
    const texts = Texts({
      'de': {'settings': 'Optionen', 'hello': 'Hallo {name}'},
      'en': {'hello': 'Hello {name}', 'only.en': 'Only English'},
    });
    expect(texts('de', 'settings'), 'Optionen');
    expect(texts('en', 'settings'), 'Settings');
    expect(texts('de', 'undo'), 'Rückgängig');
    expect(texts('de', 'hello', {'name': 'Ali'}), 'Hallo Ali');
    expect(texts('de', 'only.en'), 'Only English');
    expect(texts('de', 'missing'), 'missing');
  });

  test('every app has a tagline in each language', () {
    for (final app in FamilyApps.all) {
      for (final lang in languages.keys) {
        expect(app.tagline[lang], isNotEmpty, reason: '${app.id} $lang');
      }
    }
  });

  test('gold stays readable: dark gold on light, bright gold on dark', () {
    expect(familyGold(Brightness.light).computeLuminance(), lessThan(0.3));
    expect(familyGold(Brightness.dark).computeLuminance(), greaterThan(0.5));
  });

  testWidgets('the wordmark shows both names, read out as the Latin one', (tester) async {
    await tester.pumpWidget(_app(const AppWordmark(FamilyApps.zaki)));
    expect(find.textContaining('Zaki'), findsOneWidget);
    expect(find.textContaining('زكي'), findsOneWidget);
    expect(find.bySemanticsLabel('Zaki'), findsOneWidget);
  });

  testWidgets('More from us lists the other apps, never the current one', (tester) async {
    await tester.pumpWidget(_app(const MoreFromUs(current: FamilyApps.sakina, lang: 'de')));
    expect(find.text('Mehr von uns'), findsOneWidget);
    expect(find.textContaining('Sakina'), findsNothing);
    expect(find.textContaining('Zaki'), findsOneWidget);
    expect(find.textContaining('Majlis'), findsOneWidget);
    expect(find.textContaining('Bald verfügbar'), findsNWidgets(3), reason: 'no links yet');
    expect(find.textContaining('Ease'), findsOneWidget);
  });

  testWidgets('pickers report the choice', (tester) async {
    String? lang;
    ThemeMode? mode;
    await tester.pumpWidget(_app(Column(children: [
      LanguagePicker(lang: 'de', onChanged: (v) => lang = v),
      ThemePicker(lang: 'en', mode: ThemeMode.system, onChanged: (v) => mode = v),
    ])));
    await tester.tap(find.text('English'));
    await tester.tap(find.text('Dark'));
    expect(lang, 'en');
    expect(mode, ThemeMode.dark);
  });

  testWidgets('pop-in shows its child at once when motion is reduced', (tester) async {
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: _app(const PopIn(delay: Duration(seconds: 5), child: Text('hi'))),
    ));
    await tester.pump();
    final fade = tester.widget<FadeTransition>(find.ancestor(of: find.text('hi'), matching: find.byType(FadeTransition)).first);
    expect(fade.opacity.value, 1);
    await tester.pump(const Duration(seconds: 5)); // let the start timer finish
  });
}
