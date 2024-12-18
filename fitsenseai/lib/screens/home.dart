import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitSensei'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _firebase.signOut();
            });
          },
          icon: const Icon(Icons.logout_rounded),
        ),
      ),
    );
  }
}
