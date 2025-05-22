import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:edgar_software_testing_midterm/viewmodels/auth_viewmodel.dart';
import 'package:edgar_software_testing_midterm/models/user.dart';
import 'package:edgar_software_testing_midterm/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthViewModel authViewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    authViewModel = AuthViewModel();
    authViewModel.authService = mockAuthService; // inject mock
  });

  test('TC_AUTH_VM_001: Validate Empty Username', () {
    final result = authViewModel.validateUsername('');
    expect(result, 'Username cannot be empty.');
  });

  test('TC_AUTH_VM_002: Validate Short Password', () {
    final result = authViewModel.validatePassword('123');
    expect(result, 'Password must be at least 6 characters long.');
  });

  test('TC_AUTH_VM_003: Successful Login', () async {
    when(mockAuthService.login('testuser', 'password123')).thenAnswer(
      (_) async => {
        'accessToken': 'mock-token',
        'username': 'testuser',
      },
    );

    final result = await authViewModel.login(
      User(username: 'testuser', password: 'password123'),
    );

    expect(result, true);
    expect(authViewModel.isLoggedIn, true);
    expect(authViewModel.token, 'mock-token');
  });

  test('TC_AUTH_VM_004: Login with Invalid Credentials', () async {
    when(mockAuthService.login('invaliduser', 'wrongpassword'))
        .thenThrow(Exception('Invalid username or password.'));

    final result = await authViewModel.login(
      User(username: 'invaliduser', password: 'wrongpassword'),
    );

    expect(result, false);
    expect(authViewModel.isLoggedIn, false);
    expect(authViewModel.token, isNull);
  });

  test('TC_AUTH_VM_005: Logout Functionality', () async {
    authViewModel.isLoggedIn = true;
    authViewModel.token = 'some-token';

    await authViewModel.logout();

    expect(authViewModel.isLoggedIn, false);
    expect(authViewModel.token, isNull);
  });

  test('TC_AUTH_VM_006: Username Length Boundary Values', () {
    final validResult = authViewModel.validateUsername('user1');
    final invalidResult = authViewModel.validateUsername('');
    expect(validResult, isNull);
    expect(invalidResult, 'Username cannot be empty.');
  });

  test('TC_AUTH_VM_007: Password Length Boundary Values', () {
    final validResult = authViewModel.validatePassword('123456');
    final invalidResult = authViewModel.validatePassword('123');
    expect(validResult, isNull);
    expect(invalidResult, 'Password must be at least 6 characters long.');
  });

  test('TC_AUTH_VM_008: Login with Special Characters in Username', () {
    final result = authViewModel.validateUsername('user@name');
    expect(result, 'Username cannot contain special characters.');
  });

  test('TC_AUTH_VM_009: Login with SQL Injection Attempt', () async {
    when(mockAuthService.login("' OR '1'='1", 'any'))
        .thenThrow(Exception('Invalid username or password.'));

    final result = await authViewModel.login(
      User(username: "' OR '1'='1", password: 'any'),
    );

    expect(result, false);
    expect(authViewModel.isLoggedIn, false);
    expect(authViewModel.token, isNull);
  });

  test('TC_AUTH_VM_010: Login with Empty Fields', () {
    final user = User(username: '', password: '');
    final usernameValidation = authViewModel.validateUsername(user.username);
    final passwordValidation = authViewModel.validatePassword(user.password);

    expect(usernameValidation, 'Username cannot be empty.');
    expect(passwordValidation, 'Password must be at least 6 characters long.');
  });
}
