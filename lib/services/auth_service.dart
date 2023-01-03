import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
        uid: user.uid,
        email: user.email,
        username: user.displayName,
        imgUrl: user.photoURL);
  }

  checkUser(auth.User? user) {
    return _userFromFirebase(user);
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(credential.user);
  }

  Future<User?> createUser(
      String email, String password, String username) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user!.uid.isNotEmpty) {
      credential.user!.updateDisplayName(username);
    }
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
