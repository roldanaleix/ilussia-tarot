import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user.displayName ?? 'Usuario';
    final email = user.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => AuthService.instance.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Salir',
          )
        ],
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null ? const Icon(Icons.person, size: 32) : null,
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 20)),
          if (email.isNotEmpty) Text(email),
        ]),
      ),
    );
  }
}
