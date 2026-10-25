// The apps in the family: name, Arabic name, colour and one line about each.
import 'package:flutter/material.dart';

class FamilyApp {
  const FamilyApp({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.seed,
    required this.icon,
    required this.tagline,
    this.url,
  });

  final String id;
  final String name;
  final String nameArabic;

  /// The app's own colour; the theme is built from it.
  final Color seed;
  final IconData icon;
  final Map<String, String> tagline; // by language
  /// Store or web link; null while there is none, and the entry is then not tappable.
  final String? url;

  String taglineIn(String lang) => tagline[lang] ?? tagline['en']!;
}

abstract final class FamilyApps {
  static const sakina = FamilyApp(
    id: 'sakina',
    name: 'Sakina',
    nameArabic: 'سكينة',
    seed: Color(0xFF0F766E), // calm teal
    icon: Icons.auto_stories_rounded,
    tagline: {'de': 'Quran-Verse als Erinnerung, nach Thema', 'en': 'Quran verses as reminders, by topic'},
  );

  static const zaki = FamilyApp(
    id: 'zaki',
    name: 'Zaki',
    nameArabic: 'زكي', // zakiyy, with ز: "pure", from the same root as zakat. Not ذكي ("smart").
    seed: Color(0xFF1B6B4A), // deep green
    icon: Icons.volunteer_activism_rounded,
    tagline: {'de': 'Zakat einfach berechnen', 'en': 'Work out your zakat'},
  );

  static const majlis = FamilyApp(
    id: 'majlis',
    name: 'Majlis',
    nameArabic: 'مجلس',
    seed: Color(0xFF6D5BD0), // night indigo
    icon: Icons.nightlight_round,
    tagline: {'de': 'Das Quiz für eure Runde', 'en': 'The quiz for your gathering'},
  );

  static const ease = FamilyApp(
    id: 'ease',
    name: 'Ease',
    nameArabic: 'راحة', // rāḥa: rest, comfort
    seed: Color(0xFF3D5F8F), // dusk blue
    icon: Icons.air_rounded,
    tagline: {'de': 'Ruhe für Körper und Kopf, in wenigen Minuten', 'en': 'Calm body and mind in a few minutes'},
  );

  static const all = [sakina, zaki, majlis, ease];
}
