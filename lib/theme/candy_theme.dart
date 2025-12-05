import 'package:flutter/material.dart';

class CandyTheme {
  static const Color primaryColor = Color(0xFFFF4081);
  static const Color secondaryColor = Color(0xFF00E5FF);
  static const Color accentColor = Color(0xFFFFEA00);
  static const Color backgroundColorStart = Color(0xFF880E4F);
  static const Color backgroundColorEnd = Color(0xFF311B92);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundColorStart, backgroundColorEnd],
  );

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4.0,
              color: Colors.black45,
            ),
          ],
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 3.0,
              color: Colors.black38,
            ),
          ],
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

