// theme_provider.dart
import 'package:flutter/material.dart';

import '../models/theme_models/theme_controller.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeController _themeController = ThemeController();
  bool _isDarkTheme = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkTheme => _isDarkTheme;

  Future<void> _loadTheme() async {
    _isDarkTheme = await _themeController.loadTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _themeController.toggleTheme(_isDarkTheme);
    notifyListeners();
  }
}
