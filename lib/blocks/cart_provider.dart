import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends ChangeNotifier {
  Cart() {
    cartFromLocal();
  }
  List<Map<dynamic, dynamic>> _cart = [];
  List<String> _localCart = [];
  List<Map<dynamic, dynamic>> get cart => _cart;

  cartFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List? localStorage = await prefs.getStringList('localCart');
    if (localStorage == null) {
      return null;
    }

    localStorage.forEach((stringItem) {
      Map itemMap = jsonDecode(stringItem);
      _localCart.add(stringItem);
      _cart.add(itemMap);
    });
    notifyListeners();
  }

  bool isInCart(String id) {
    bool isIn = false;
    _cart.forEach((element) {
      if (element['id'] == id) {
        isIn = true;
      }
    });
    return isIn;
  }

  void clearCart() {
    _cart.clear();
    updateLocalCart();
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cart[index]['quantity'] += 1;
    updateLocalCart();
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    _cart[index]['quantity'] -= 1;
    updateLocalCart();
    notifyListeners();
  }

  void updateLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    _localCart.clear();
    _cart.forEach((element) {
      _localCart.add(jsonEncode(element));
    });
    prefs.setStringList('localCart', _localCart);
  }

  int addtoCart(Map product) {
    _cart.add(product);
    updateLocalCart();
    notifyListeners();
    return _cart.indexOf(product);
  }

  removeProduct(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _cart.removeAt(index);
    updateLocalCart();
    notifyListeners();
  }

  int cartCount() => _cart.length;
}
