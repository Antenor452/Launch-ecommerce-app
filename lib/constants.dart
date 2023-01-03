import 'package:intl/intl.dart';

const currencySymb = 'Gh¢';
NumberFormat currencyFormat = NumberFormat.currency(
  locale: "en_us",
  symbol: currencySymb,
  decimalDigits: 2,
  customPattern: " ###,###.00#",
);
