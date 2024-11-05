// theme_model.dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel {
  static const String _themeKey = 'isDarkTheme';

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default is light theme
  }

  Future<void> setThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDark);
  }
}
