import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/main_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true; // Toggle between Login and Sign-Up
  bool _isLoading = false;

  // Handle user authentication (Login or Sign-Up)
  Future<void> _authenticateUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Login logic
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logged in successfully!")),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        // Sign-Up logic
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account created successfully!")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? "Login" : "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Email Input Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                // Password Input Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // Action Button (Login/Sign-Up)
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _authenticateUser,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
                        child: Text(_isLogin ? "Login" : "Sign Up"),
                      ),
                SizedBox(height: 10),
                // Toggle between Login and Sign-Up
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
