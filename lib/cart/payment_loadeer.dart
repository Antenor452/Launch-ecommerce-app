import 'package:flutter/material.dart';

class PaymentLoader extends ChangeNotifier {
  bool isLoading = false;

  updateLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }
}
