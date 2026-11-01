import 'package:flutter/material.dart';

class AppTheme {
  // Brand Palette:
  // • #F4F7F5 — main light background
  // • #FFFFFF — cards
  // • #E2EDE7 — filters and secondary blocks background
  // • #C9DDD3 — borders and dividers
  // • #062B20 — dark green navigation and contrast blocks
  // • #155A43 — secondary green surfaces
  // • #14805C — primary green accent: buttons and active elements
  // • #FFD51A — yellow accent: progress bars, favorites, achievement badges
  // • #172D25 — primary text on light background
  // • #60736A — secondary text
  // • #FFFFFF — text on green surfaces

  static const Color background = Color(0xFFF4F7F5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFE2EDE7);
  static const Color border = Color(0xFFC9DDD3);
  static const Color darkNav = Color(0xFF062B20);
  static const Color greenSurface = Color(0xFF155A43);
  static const Color primary = Color(0xFF14805C); // Green accent: buttons & active elements
  static const Color accentYellow = Color(0xFFFFD51A); // Yellow accent: progress & badges
  static const Color textMain = Color(0xFF172D25);
  static const Color textSecondary = Color(0xFF60736A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onYellow = Color(0xFF062B20);

  // Compatibility aliases
  static const Color surface = surfaceCard;
  static const Color surfaceElevated = surfaceSecondary;
  static const Color surfaceBorder = border;
  static const Color textPrimary = textMain;
  static const Color textMuted = textSecondary;
  static const Color secondary = darkNav;
  static const Color accentRose = Color(0xFFEF4444);
  static const Color accentGold = accentYellow;
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFFF8A00);
  static const Color accentGreen = primary;

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double screenPadding = 16.0;
  static const double buttonHeight = 48.0;

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withAlpha(50),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  static List<BoxShadow> get goldGlow => [
        BoxShadow(
          color: accentYellow.withAlpha(60),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ];

  static const LinearGradient heroGradient = LinearGradient(
    colors: [darkNav, greenSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = heroGradient;
  static const LinearGradient rewardsGradient = heroGradient;
  static const LinearGradient profileGradient = heroGradient;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accentYellow,
        surface: surfaceCard,
        error: accentRose,
        onPrimary: onPrimary,
        onSecondary: onYellow,
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: border),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkNav,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkNav,
        selectedItemColor: accentYellow,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
