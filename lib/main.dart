import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_app/views/loading_page.dart';
import 'package:flutter/material.dart';

import 'views/connection_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuthApp',
      home: RealyHomePage(),
    );
  }
}

class RealyHomePage extends StatefulWidget {
  const RealyHomePage({super.key});

  @override
  State<RealyHomePage> createState() => _RealyHomePageState();
}

class _RealyHomePageState extends State<RealyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const LoadingPage();
            } else {
              return const ConnectionPage();
            }
          }),
    );
  }
}
