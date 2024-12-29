import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color inUseColor = Colors.red[100]!;
final Color selectedColor = Colors.blue[100]!;

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => isDarkMode ? getDarkMode() : getLightMode();

  ThemeData getDarkMode() {
    const primary = Color(0xff234783);
    const secondary = Color(0xffEEC52C);

    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: secondary,
      ),
      appBarTheme: const AppBarTheme(color: primary),
    );
  }

  ThemeData getLightMode() {
    const primary = Color(0xff234783);
    const secondary = Color(0xffEEC52C);

    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primary, foregroundColor: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(15),
        labelStyle: const TextStyle(color: primary, fontSize: 20),
        suffixIconColor: Colors.grey,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          primary: primary,
          onPrimary: Colors.white,
          secondary: secondary,
          error: Colors.red,
          onError: Colors.green),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w400,
          fontSize: 25,
        ),
      ),
    );
  }

  AppTheme copyWith({int? selectedColor, bool? isDarkMode}) =>
      AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
}
