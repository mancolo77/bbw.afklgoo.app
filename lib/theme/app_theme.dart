import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Melbet Signature Brand Colors
  static const Color primary = Color(0xFFF3B204); // Melbet Signature Amber Gold
  static const Color primaryDark = Color(0xFFD49A00);
  static const Color primaryLight = Color(0xFFFFC72C);
  static const Color secondary = Color(0xFFFF6B00); // Melbet Energy Orange
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentGold = Color(0xFFF3B204);
  static const Color accentRose = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFFF7700);
  static const Color accentGreen = Color(0xFF10B981);

  // Background Surfaces (Melbet Deep Slate Charcoal)
  static const Color background = Color(0xFF101216); // Deep Slate Obsidian
  static const Color surface = Color(0xFF161920); // Dark Slate Surface
  static const Color surfaceCard = Color(0xFF1F232C); // Elevated Card Surface
  static const Color surfaceElevated = Color(0xFF282C38);
  static const Color surfaceBorder = Color(0xFF2D323E); // Sleek Border

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF959CAE);
  static const Color textMuted = Color(0xFF5F6677);

  // Melbet Signature Brand Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF28200A), Color(0xFF15171E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFF2E1E08), Color(0xFF16131A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rewardsGradient = LinearGradient(
    colors: [Color(0xFF2B1A08), Color(0xFF15141C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient profileGradient = LinearGradient(
    colors: [Color(0xFF212530), Color(0xFF13151C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Box Shadows
  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withAlpha(65),
          blurRadius: 18,
          spreadRadius: 1,
        ),
      ];

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: accentRose,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF101216),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
