import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  String? validateUsername(String username) {
    if (username.isEmpty) return "Username can't be empty";
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  Future<bool> login(User user) async {
    try {
      final response = await _authService.login(user.username, user.password);
      _token = response['accessToken'];
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _token = null;
    notifyListeners();
  }
}
