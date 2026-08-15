import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF9A1750);
  static const Color _primaryDark = Color(0xFF5D001E);
  static const Color _secondary = Color(0xFFEE4C7C);
  static const Color _accent = Color(0xFFE3AFBC);
  static const Color _background = Color(0xFFE3E2DF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _background,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _secondary,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        background: _background,
        onBackground: _primaryDark,
        surface: Colors.white, // Card, Dialog gibi yüzeylerin rengi
        onSurface: _primaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _primary),
      ),
    );
  }
}
