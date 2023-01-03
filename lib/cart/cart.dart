import 'dart:convert';
import 'dart:io';
import 'package:flutter_ecommerce_ui_kit/cart/payment_loadeer.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/auth_provider.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../blocks/cart_provider.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  String publicKey = 'pk_test_f1423130a2d786b7138b80aafb3a5cca9fa425c3';
  // final plugin = PaystackPlugin();
  @override
  void initState() {
    // plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool payOnDelivery = false;
  late double subTotal;
  late double tax;
  late double shipping = 5.0;
  late double total;

  // PaymentCard _getCard() {
  //   return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  // }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future ChargeCard(int amount, String email) async {
    // Charge charge = Charge()
    //   ..amount = amount * 100
    //   ..email = email
    //   ..currency = "GHS"
    //   ..accessCode = "GH"
    //   ..reference = _getReference()
    //   ..card = _getCard();

    // CheckoutResponse response = await plugin.checkout(
    //   context,
    //   charge: charge,
    //   method: CheckoutMethod.selectable,
    //   fullscreen: false,
    // );
    // print(response);
    // return response.status;
    Map<String, dynamic> body = {
      'amount': amount.toString(),
      'currency': "usd",
      'payment_method_types[]': 'card'
    };

    var response =
        await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
            headers: {
              'Authorization':
                  'Bearer sk_test_51Lxe55KvDZtuz22QDYIHanKie3dKzYvDC9fujeXD1m22Ar89jNkeTJZ7emyExZJ2A3dIuXbr6yNtiwMf1jSPsbSG00gC2AklTq',
              'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body);
    print(response.body);
    return jsonDecode(response.body);
  }

  void calcSubTotal(List prods) {
    subTotal = 0;
    prods.forEach((item) {
      subTotal = subTotal + (item['price'] * item['quantity']);
      print(subTotal);
    });
    tax = 0.125 * subTotal;
    total = subTotal + shipping + tax;
  }

  updatePayOnDelivery() {
    setState(() {
      payOnDelivery = !payOnDelivery;
    });
  }

  addToOrders(Map<String, dynamic> order) {
    db.collection("orders").add(order);
    Provider.of<Cart>(context, listen: false).clearCart();
  }

  Future<void> confirmOrder(Map<String, dynamic> order) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cofirm Order'),
            content: Text(
                'An amount of $currencySymb ${currencyFormat.format(total)} will be taken by the rider'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  addToOrders(order);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Order placed successfully"),
                    ),
                  );
                },
                child: Text('Confirm Order'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  initiatePayment(Function updateStatus) async {
    if (_formKey.currentState!.validate()) {
      var user = await Provider.of<AuthBlock>(context, listen: false).user;
      var cart = Provider.of<Cart>(context, listen: false).cart;
      String username = user!.username.toString();
      String userEmail = user.email.toString();
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String address = addressController.text;
      String phone = phoneController.text;

      Map<String, dynamic> order = {
        'UserId': userId,
        'Email': userEmail,
        'Username': username,
        'Delivery Address': address,
        'Contact Phone': phone,
        'Products Ordered': cart,
        'Subtotal': subTotal,
        'Delivery Fee': shipping,
        'Taxes': tax,
        'TotalAmount': total,
        'Payment Method': payOnDelivery ? 'Pay on Delivery' : 'Paystack',
        'Status': 'Open',
        'Progress': 'Processing',
        'Date': Timestamp.fromDate(DateTime.now())
      };
      if (payOnDelivery) {
        confirmOrder(order);
      } else {
        var paymentIntent = await ChargeCard(total.toInt(), 'USD');
        print('starting');
        updateStatus(true);
        await Stripe.instance
            .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            merchantDisplayName: 'Pay $total\$ to  Launch App',
            style: ThemeMode.dark,
            appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
                  background: Colors.white,
                  primary: Colors.blue,
                  componentText: Colors.blue,
                  componentBorder: Colors.black,
                  primaryText: Colors.black,
                  secondaryText: Colors.black,
                  placeholderText: Colors.grey),
            ),
          ),
        )
            .then((value) {
          Stripe.instance.presentPaymentSheet().then((value) {
            addToOrders(order);
            Navigator.of(context).pop();
            updateStatus(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Order placed succesfully"),
              ),
            );
          }).onError((error, stackTrace) {
            print('error');
            print(error);
            Navigator.of(context).pop();
            updateStatus(false);
            Fluttertoast.showToast(msg: 'Payment Failed');
          });
        });
        paymentIntent = null;
      }
    }
  }

  Future<void> _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: ((context) {
        return SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.symmetric(
            //   vertical: 50,
            //   horizontal: 8,
            // ),
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Confirm Checkout',
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid address for delivery';
                          }
                        },
                        decoration: InputDecoration(
                          label: Text('Please enter a delivery address'),
                        ),
                      ),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().length != 10) {
                            return 'Please enter a valid phone number';
                          }
                        },
                        decoration: InputDecoration(
                          label: Text('Please enter your phone number'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () {
                    var updateStatus =
                        Provider.of<PaymentLoader>(context, listen: false)
                            .updateLoadingStatus;
                    initiatePayment(updateStatus);
                  },
                  child: payOnDelivery
                      ? Text("Confirm Order")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Consumer<PaymentLoader>(
                                builder: (context, value, child) {
                              return value.isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Proceed to Payment',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    );
                            })
                          ],
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Back to Cart'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: ((context, value, child) {
          calcSubTotal(value.cart);
          return value.cart.isNotEmpty
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Container(
                        child: Text(
                          value.cart.length.toString() + " ITEMS IN YOUR CART",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                          itemCount: value.cart.length,
                          itemBuilder: (context, index) {
                            final item = value.cart[index];
                            final name = item['name'];
                            print(item['price']);
                            final price = currencyFormat.format(
                              double.parse(item['price'].toString()),
                            );
                            final image = item['image'];
                            final quantity = item['quantity'];

                            return Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              key: Key(UniqueKey().toString()),
                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              direction: DismissDirection.endToStart,
                              dismissThresholds: {
                                DismissDirection.endToStart: 0.8
                              },
                              onDismissed: (direction) {
                                // Then show a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("$name dismissed"),
                                        duration: Duration(seconds: 1)));
                                setState(() {
                                  value.removeProduct(index);
                                  calcSubTotal(value.cart);
                                });
                              },
                              // Show a red background as the item is swiped away.
                              background: Container(
                                decoration: BoxDecoration(color: Colors.red),
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                decoration: BoxDecoration(color: Colors.red),
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Divider(
                                    height: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: ListTile(
                                      trailing: Text('$currencySymb $price'),
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Container(
                                          width: 50,
                                          decoration:
                                              BoxDecoration(color: Colors.blue),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: image,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        name,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Consumer<Cart>(
                                              builder: (context, value, child) {
                                                return Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        if (quantity > 1) {
                                                          value
                                                              .decreaseQuantity(
                                                                  index);
                                                        }
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color: quantity == 1
                                                                ? Colors.grey
                                                                : Colors.red),
                                                        child: Center(
                                                            child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      height: 20,
                                                      width: 20,
                                                      child: Center(
                                                        child: Text(
                                                          '$quantity',
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        value.increaseQuantity(
                                                            index);
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue),
                                                        child: Center(
                                                          child: Text(
                                                            '+',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Column(
                      children: [
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      "TOTAL",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )),
                                    Text(
                                        "$currencySymb ${currencyFormat.format(total)}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text("Subtotal",
                                            style: TextStyle(fontSize: 14))),
                                    Text(
                                        "$currencySymb ${currencyFormat.format(subTotal)}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text("Shipping",
                                            style: TextStyle(fontSize: 14))),
                                    Text(
                                        "$currencySymb ${currencyFormat.format(shipping)}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text("Tax",
                                            style: TextStyle(fontSize: 14))),
                                    Text(
                                        " $currencySymb  ${currencyFormat.format(tax)}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: updatePayOnDelivery,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      payOnDelivery
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.lightBlue,
                                            )
                                          : Icon(Icons.check_circle_outline),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Pay on Delivery')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 50, bottom: 10),
                          child: ButtonTheme(
                            buttonColor: Theme.of(context).primaryColor,
                            minWidth: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Please login to Proceed');
                                } else {
                                  _showBottomSheet();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "CHECKOUT",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Please Add items to your cart to proceed',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                );
        }),
      ),
    );
  }
}
