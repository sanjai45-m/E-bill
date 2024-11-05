import 'theme_model.dart';

class ThemeController {
  final ThemeModel _themeModel = ThemeModel();

  Future<bool> loadTheme() async {
    return await _themeModel.getThemePreference();
  }

  Future<void> toggleTheme(bool isDark) async {
    await _themeModel.setThemePreference(isDark);
  }
}
