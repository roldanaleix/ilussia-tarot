import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../presentation/pages/login/login_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../services/auth_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: StreamBuilder<User?>(
        stream: AuthService.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) return const LoginPage();
          return HomePage(user: user);
        },
      ),
    );
  }
}
