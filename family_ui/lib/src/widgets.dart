// Small pieces every app uses: wordmark, section headers, hints, pickers, "More from us".
import 'package:flutter/material.dart';

import 'apps.dart';
import 'texts.dart';
import 'theme.dart';

/// The app's name with its Arabic name in gold: the family's signature.
class AppWordmark extends StatelessWidget {
  const AppWordmark(this.app, {super.key, this.style});

  final FamilyApp app;

  /// Style of the Latin name; the Arabic name is drawn a little larger, in gold.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latin = style ?? DefaultTextStyle.of(context).style;
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: app.name, style: latin),
        TextSpan(text: '  ·  ', style: latin.copyWith(color: theme.colorScheme.outline)),
        TextSpan(
          text: app.nameArabic,
          style: latin.copyWith(
            color: familyGold(theme.brightness),
            fontSize: (latin.fontSize ?? 20) * 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]),
      semanticsLabel: app.name,
    );
  }
}

/// Section title in the app's colour, with an optional action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 8, 4),
        child: Row(children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ),
          ?trailing,
        ]),
      );
}

/// Label above a control.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      );
}

/// Muted explanatory text.
class Hint extends StatelessWidget {
  const Hint(this.text, {super.key, this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4)});

  final String text;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, height: 1.4)),
      );
}

/// The standard side padding of list content.
class Padded extends StatelessWidget {
  const Padded(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: child);
}

/// Label on the left, value on the right.
class ValueRow extends StatelessWidget {
  const ValueRow(this.label, this.value, {super.key, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: color))),
          Text(value, style: TextStyle(color: color, fontFeatures: const [FontFeature.tabularFigures()])),
        ]),
      );
}

/// Centered icon + message (+ optional button) for empty screens.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.text, this.action, this.onAction});

  final IconData icon;
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            if (action != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onAction, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// A snackbar with an undo button.
void showUndo(BuildContext context, {required String lang, required String message, required VoidCallback onUndo}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: familyTexts(lang, 'undo'), onPressed: onUndo),
    ));
}

/// Deutsch | English
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key, required this.lang, required this.onChanged});

  final String lang;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<String>(
        segments: [for (final e in languages.entries) ButtonSegment(value: e.key, label: Text(e.value))],
        selected: {lang},
        onSelectionChanged: (s) => onChanged(s.first),
      );
}

/// System | Light | Dark
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key, required this.lang, required this.mode, required this.onChanged});

  final String lang;
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<ThemeMode>(
        segments: [for (final m in ThemeMode.values) ButtonSegment(value: m, label: Text(familyTexts(lang, 'theme.${m.name}')))],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
      );
}

/// The family's promise, shown in every app's settings.
class PrivacyPromise extends StatelessWidget {
  const PrivacyPromise({super.key, required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Icon(Icons.lock_outline, color: familyGold(theme.brightness)),
            const SizedBox(width: 12),
            Expanded(child: Text(familyTexts(lang, 'promise'), style: theme.textTheme.bodyMedium?.copyWith(height: 1.4))),
          ]),
        ),
      ),
    );
  }
}

/// "More from us": the other apps of the family, for the settings screen.
class MoreFromUs extends StatelessWidget {
  const MoreFromUs({super.key, required this.current, required this.lang, this.onOpen});

  final FamilyApp current;
  final String lang;

  /// Opens an app's link. Apps without a link show "Coming soon".
  final void Function(String url)? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(familyTexts(lang, 'family.more')),
        for (final app in FamilyApps.all.where((a) => a.id != current.id))
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: app.seed, borderRadius: BorderRadius.circular(12)),
              child: Icon(app.icon, color: familyGold(Brightness.dark), size: 24),
            ),
            title: AppWordmark(app, style: theme.textTheme.titleMedium),
            subtitle: Text(app.url == null ? '${app.taglineIn(lang)} · ${familyTexts(lang, 'family.soon')}' : app.taglineIn(lang)),
            trailing: app.url == null || onOpen == null ? null : const Icon(Icons.open_in_new, size: 18),
            onTap: app.url == null || onOpen == null ? null : () => onOpen!(app.url!),
          ),
      ],
    );
  }
}
