import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthServiceBase {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout();
}

class AuthService implements AuthServiceBase {
  final String _baseUrl;
  final http.Client _client;

  // Constructor with dependency injection
  AuthService({
    String baseUrl = 'https://dummyjson.com/auth',
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw AuthException(
          'Login failed: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException {
      throw AuthException('Network error occurred', 0);
    } on FormatException {
      throw AuthException('Invalid server response', 0);
    }
  }

  @override
  Future<void> logout() async {
    // Simulate logout delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, this.statusCode);

  @override
  String toString() => 'AuthException: $message (Status: $statusCode)';
}