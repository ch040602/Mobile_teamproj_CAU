import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


  class Authprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
  await _auth.signInWithEmailAndPassword(email: email, password: password);
  notifyListeners();
  } catch (e) {
  throw e;
  }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
  try {
  await _auth.createUserWithEmailAndPassword(email: email, password: password);
  notifyListeners();
  } catch (e) {
  throw e;
  }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}