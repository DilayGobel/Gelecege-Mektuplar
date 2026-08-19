import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF9A1750);
  static const Color _secondary = Color(0xFFEE4C7C);
  static const Color _accent = Color(0xFFE3AFBC);
  static const Color _background = Color(0xFFE3E2DF);
  static const Color _primaryDark = Color(0xFF5D001E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _background,
      colorScheme: ColorScheme.light(
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _secondary,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white, // Arka plan üzerindeki metin rengi
        surface: Colors.white, // Card, Dialog gibi yüzeylerin rengi
        onSurface:
            _primaryDark, // Yüzeyler üzerindeki metin rengi (Başlıklar vs.)
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
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none, // Kenarlık olmasın
        ),
        prefixIconColor: _primaryDark,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(
          color: _primary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        selectedColor: _secondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      cardTheme: const CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: _accent, width: 1.5),
        ),
        // Kartların iç rengi colorScheme.surface'ten (_background) gelecektir.
      ),
    );
  }
}
