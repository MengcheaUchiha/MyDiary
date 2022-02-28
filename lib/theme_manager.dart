import 'package:flutter/material.dart';
import 'package:flutter_mydiary/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemePreferences _themePreferences = ThemePreferences();

  Color _color = Colors.pink;
  String _bg = 'mitsuha';
  bool _isDark = false;

  ThemeNotifier() {
    initTheme();
  }

  bool get isDark => _isDark;
  Color get color => _color;
  String get bg => _bg;

  void initTheme() async {
    _isDark = (await _themePreferences.getDarkTheme())!;
    _bg = (await _themePreferences.getBg())!;
    _color = getColor(_bg)!;
    notifyListeners();
  }

  void toggleTheme() {
    _isDark = !isDark;
    _themePreferences.saveDarkTheme(isDark);
    notifyListeners();
  }

  void saveTheme(String theme) async {
    _themePreferences.saveBg(theme);
    _bg = (await _themePreferences.getBg())!;
    _color = getColor(_bg)!;
    notifyListeners();
  }
}

class ThemePreferences {
  Future<bool?> getDarkTheme() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    bool isDark = _shared.getBool('isDark') ?? false;
    print('$isDark');
    return isDark;
  }

  void saveDarkTheme(bool isDark) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.setBool('isDark', isDark);
  }

  Future<String?> getBg() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String theme = _shared.getString('theme') ?? 'mitsuha';
    print('$theme');
    return theme;
  }

  void saveBg(String theme) async {
    print(theme);
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.setString('theme', theme);
  }
}
