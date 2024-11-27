import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/auth_screen.dart';
import 'package:todo_app/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAZgmNob8DUH-njvZAleGUKdX_ITc2xYdg',
          appId: '1:765088895247:web:c1e59064c5db1de3a7ee7a',
          messagingSenderId: '765088895247',
          projectId: 'todo-app-e9f78'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen(), // New initial screen
    );
  }
}

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in, navigate to MainScreen
          return MainScreen();
        } else {
          // User is not logged in, navigate to AuthenticationScreen
          return AuthenticationScreen();
        }
      },
    );
  }
}
