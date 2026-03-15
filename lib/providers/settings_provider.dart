import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = const Color(0xFF3B82F6); // Blue-500
  bool _notificationsEnabled = true;
  
  // Notification detailed settings
  bool _dailyDigest = false;
  bool _criticalAlerts = true;
  bool _showOnLockScreen = true;
  bool _showInHistory = true;
  bool _showAsBanners = true;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyDigest => _dailyDigest;
  bool get criticalAlerts => _criticalAlerts;
  bool get showOnLockScreen => _showOnLockScreen;
  bool get showInHistory => _showInHistory;
  bool get showAsBanners => _showAsBanners;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme Mode
    final themeIndex = prefs.getInt('themeMode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    // Load Primary Color
    final colorValue = prefs.getInt('primaryColor');
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }

    // Load Notifications
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _dailyDigest = prefs.getBool('dailyDigest') ?? false;
    _criticalAlerts = prefs.getBool('criticalAlerts') ?? true;
    _showOnLockScreen = prefs.getBool('showOnLockScreen') ?? true;
    _showInHistory = prefs.getBool('showInHistory') ?? true;
    _showAsBanners = prefs.getBool('showAsBanners') ?? true;

    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  void setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', color.value);
  }

  void toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
  }

  void toggleDailyDigest(bool enabled) async {
    _dailyDigest = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyDigest', enabled);
  }

  void toggleCriticalAlerts(bool enabled) async {
    _criticalAlerts = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('criticalAlerts', enabled);
  }

  void toggleShowOnLockScreen(bool enabled) async {
    _showOnLockScreen = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnLockScreen', enabled);
  }

  void toggleShowInHistory(bool enabled) async {
    _showInHistory = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showInHistory', enabled);
  }

  void toggleShowAsBanners(bool enabled) async {
    _showAsBanners = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showAsBanners', enabled);
  }
}
