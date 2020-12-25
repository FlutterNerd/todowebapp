import 'package:flutter/material.dart';
import 'package:todowebapp/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TodoWebApp",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: () {
              authService.signInWithGoogle(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Color(0xffF06543),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    "SignIn With Gooogle",
                    style: TextStyle(color: Colors.white),
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
