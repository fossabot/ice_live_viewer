import 'package:flutter/material.dart';

class MyTheme {
  ThemeData lightThemeData = ThemeData(
      primarySwatch: Colors.purple,
      useMaterial3: true,
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
        headline2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ));

  ThemeData darkThemeData = ThemeData.from(
      colorScheme: const ColorScheme.dark(),
      useMaterial3: true,
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFAC7BE8),
        ),
        headline2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFAC7BE8),
        ),
      ));
}
