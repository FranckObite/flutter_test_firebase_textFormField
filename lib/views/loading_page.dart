import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_app/views/home_page.dart';
import 'package:flutter/material.dart';

import 'connection_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 37, 65),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectionPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("${user.email!} connected"),
      ),
    );
  }
}
