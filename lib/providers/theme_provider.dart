import 'package:flutter/material.dart';
import 'package:my_news_app/services/dark_theme_preferences.dart';

// import '../services/dark_theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences darkThemePreferences = ThemePreferences();
  bool _darkTheme = false;
  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
