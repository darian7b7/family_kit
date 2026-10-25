// One set of shapes and type for every app; the colours come from the app.
import 'package:flutter/material.dart';

import 'apps.dart';

/// The family's accent: gold for the Arabic name and small highlights.
/// Darker in light mode so it stays readable on white.
Color familyGold(Brightness b) => b == Brightness.dark ? const Color(0xFFF5C451) : const Color(0xFF94680F);

/// Night colours for dark, festive screens (Majlis, celebrations).
const familyNight = Color(0xFF14123A);
const familyNightDeep = Color(0xFF0B0A24);

const _radius = 20.0;

/// The theme for [app]. Pass [scheme] to replace the colours built from the app's seed.
ThemeData familyTheme(FamilyApp app, Brightness brightness, {ColorScheme? scheme}) {
  final colors = scheme ?? ColorScheme.fromSeed(seedColor: app.seed, brightness: brightness);
  final base = ThemeData(colorScheme: colors);
  final text = base.textTheme;
  final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius));
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

  return base.copyWith(
    textTheme: text.copyWith(
      displayMedium: text.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: colors.onSurface),
    ),
    cardTheme: CardThemeData(elevation: 0, margin: EdgeInsets.zero, shape: rounded),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: buttonShape,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52), shape: buttonShape)),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: buttonShape)),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
    chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(text.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
  );
}

/// Whether the system asks for reduced motion.
bool reduceMotion(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;
