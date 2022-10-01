import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        fontFamily: 'Chillax',
        scaffoldBackgroundColor: const Color(0xff272a56),
        textTheme: const TextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      );
}
