import 'package:edgar_software_testing_midterm/page/login_view.dart';
import 'package:edgar_software_testing_midterm/page/logout_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'page/login_view.dart';
import 'page/logout_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter MVVM Login',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/logout': (context) => LogoutView(),
        },
      ),
    );
  }
}
