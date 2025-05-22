import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService _authService = AuthService();
  bool isLoggedIn = false;
  String? token;

  // ✅ Tambahkan setter agar bisa inject mock saat testing
  set authService(AuthService service) {
    _authService = service;
  }

  // Validasi username
  String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty.';
    if (RegExp(r'[^a-zA-Z0-9]').hasMatch(username)) {
      return 'Username cannot contain special characters.';
    }
    return null;
  }

  // Validasi password
  String? validatePassword(String password) {
    if (password.length < 6) return 'Password must be at least 6 characters long.';
    return null;
  }

  // Login
 Future<bool> login(User user) async {
    try {
      final response = await _authService.login(user.username, user.password);
      token = response['token'];
      isLoggedIn = true;
      return true;
    } catch (e) {
      isLoggedIn = false;
      token = null;
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    token = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
