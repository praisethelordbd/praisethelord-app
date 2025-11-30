import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isScreenAwake = false;
  bool get isDarkMode => _isDarkMode;
  bool get isScreenAwake => _isScreenAwake;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isScreenAwake = prefs.getBool('isScreenAwake') ?? false;
    WakelockPlus.toggle(enable: _isScreenAwake);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleScreenAwake(bool value) async {
    _isScreenAwake = value;
    WakelockPlus.toggle(enable: _isScreenAwake);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScreenAwake', _isScreenAwake);
    notifyListeners();
  }
}
