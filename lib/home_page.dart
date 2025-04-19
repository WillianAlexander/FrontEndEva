import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UID: ${user!.uid}'),
            SizedBox(height: 20),
            Text('DisplayName: ${user!.displayName}'),
            SizedBox(height: 20),
            Text('Email: ${user!.email}'),
            SizedBox(height: 20),
            Text('Usuario: ${user!.email!.split("@")[0]}'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              label: Text('Cerrar sesion'),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
