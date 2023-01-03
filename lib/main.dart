import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/auth_provider.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/cart_provider.dart';
import 'package:flutter_ecommerce_ui_kit/cart/payment_loadeer.dart';
import 'package:flutter_ecommerce_ui_kit/firebase_options.dart';
import 'package:flutter_ecommerce_ui_kit/orders/order_screen.dart';
import 'package:flutter_ecommerce_ui_kit/sell/add_product.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ecommerce_ui_kit/auth/auth.dart';
import 'package:flutter_ecommerce_ui_kit/cart/cart.dart';
import 'package:flutter_ecommerce_ui_kit/categories/categorise.dart';
import 'package:flutter_ecommerce_ui_kit/home/home.dart';
import 'package:flutter_ecommerce_ui_kit/localizations.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/product_detail.dart';
import 'package:flutter_ecommerce_ui_kit/settings/settings.dart';
import 'package:flutter_ecommerce_ui_kit/shop/shop.dart';
import 'package:flutter_ecommerce_ui_kit/wishlists/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      'pk_test_51Lxe55KvDZtuz22QioMrzCKaLWgBOMOYjbx6cWNE09Tmq6JCOnHH2VHwozKxsBcdO7zpXlkPr5nePXsHqFAnGHWX00f0vDBcmu';
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthBlock>(create: (_) => AuthBlock()),
    ChangeNotifierProvider<Cart>(create: (_) => Cart()),
    ChangeNotifierProvider<PaymentLoader>(create: (_) => PaymentLoader())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Locale('en');
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange.shade500,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.lightBlue.shade900),
        fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Lato',
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/auth': (BuildContext context) => Auth(),
        '/shop': (BuildContext context) => Shop(),
        '/categorise': (BuildContext context) => Categorise(),
        '/wishlist': (BuildContext context) => WishList(),
        '/cart': (BuildContext context) => CartList(),
        '/settings': (BuildContext context) => Settings(),
        '/addProduct': (BuildContext context) => UploadProduct(),
        '/orders': (context) => OrderScreen(),
      },
    );
  }
}
