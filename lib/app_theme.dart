import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF0D7FF2);
  static const Color backgroundLight = Color(0xFFF5F7F8);
  static const Color backgroundDark = Color(0xFF101922);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(
    0xFF1B2735,
  ); // Slightly lighter than background for cards

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: const ColorScheme.light(primary: primary, surface: cardLight),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: const ColorScheme.dark(primary: primary, surface: cardDark),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
