import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webtoon/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    try {
      // Authprovider 클래스를 사용하여 회원가입 수행
      await  _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 회원가입 성공 후 추가적인 작업 수행
      print('Sign up successful');
    } on FirebaseAuthException catch (e) {
      print('Sign up failed: $e');
      // 에러 처리
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    TextField(
    controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
    ),
      SizedBox(height: 16),
      TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          _signUp();
        },
        child: Text('Sign Up'),
      ),

    ],
    ),
        ),
    );
  }
}

