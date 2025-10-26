import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  void login(String username) {
    _username = username;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _username = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}