import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webtoon/screens/home_screen.dart';
import 'signup_screen.dart';
import 'dart:async';  // Timer 클래스 사용을 위해 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Login successful: ${userCredential.user?.email}');

      // 로그인 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 성공했습니다!'),
        ),
      );

      // 3초 후에 HomeScreen으로 이동
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      print('Login failed: $e');
      // 로그인 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75), // 배경색을 어둡게 설정
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0), // 위아래로 여백 추가
              child: Text(
                'Welcome to Webtoonierse!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0, // 제목 폰트 크기 조절
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 60,),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white), // 글씨를 하얀색으로 설정
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // 라벨 글씨를 하얀색으로 설정
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white), // 글씨를 하얀색으로 설정
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white), // 라벨 글씨를 하얀색으로 설정
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _navigateToSignUp,
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.white), // 글씨를 하얀색으로 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}

