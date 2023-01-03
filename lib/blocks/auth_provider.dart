import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as model;

class AuthBlock extends ChangeNotifier {
  model.User? user;
  AuthBlock() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.setUser(user);
    });
  }
  final storage = FlutterSecureStorage();
  final _authService = AuthService();

  bool isLoggedIn = false;
  bool isLoading = false;
  String loadingType = '';
  String loginType = 'LOGIN';
  String createType = 'CREATE';

  setUser(User? currentUser) {
    user = _authService.checkUser(currentUser);
    if (user != null) {
      setIsLoggedIn(true);
    }
  }

  login(String email, String password, Function callBack) async {
    setIsLoading(true);
    try {
      user = await _authService.signIn(email, password);
      if (user!.uid!.isNotEmpty) {
        callBack();
        setIsLoggedIn(true);
      }
      setIsLoading(false);
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            msg: 'Invalid Credentials',
            gravity: ToastGravity.BOTTOM);
      }
    }
  }

  createAccount(
      String email, String password, String username, callBack) async {
    setIsLoading(true);
    try {
      user = await _authService.createUser(email, password, username);
      if (user!.uid!.isNotEmpty) {
        callBack();
        setIsLoggedIn(true);
      }
      setIsLoading(false);
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak');
      }
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email already in use');
      }
    }
  }

  setLoadingType(String type) {
    loadingType = type;
  }

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setIsLoggedIn(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    _authService.signOut().then((value) {
      setIsLoggedIn(false);
      prefs.clear();
    });
  }
}
