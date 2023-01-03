import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/orders/order_tile.dart';
import '../services/firestore_services.dart';

class OpenOrderScreen extends StatefulWidget {
  const OpenOrderScreen({Key? key}) : super(key: key);

  @override
  State<OpenOrderScreen> createState() => _OpenOrderScreenState();
}

class _OpenOrderScreenState extends State<OpenOrderScreen> {
  @override
  Widget build(BuildContext context) {
    cancelOrder(String orderId) {
      db
          .collection("orders")
          .doc(orderId)
          .update({'Status': 'Closed', 'Progress': 'Cancelled'});
    }

    Future<void> confirmCancel(String orderId) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Order Cancelletion'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to cancel your order?'),
                  Text(
                      'If payment has already been proccessed a payment will be refunded within 3 working days')
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    cancelOrder(orderId);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text('Confirm Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                  ),
                ),
              ],
            );
          });
    }

    Future<QuerySnapshot> getOrders() async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      return db
          .collection("orders")
          .where('UserId', isEqualTo: userId)
          .where('Status', isEqualTo: 'Open')
          .orderBy('Date')
          .get();
    }

    return FutureBuilder<QuerySnapshot>(
      future: getOrders(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error connecting to Server'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (snapshot.data!.size == 0) {
          return const Center(
            child: Text('No orders placed'),
          );
        }
        final List<QueryDocumentSnapshot> orderList = snapshot.data!.docs;

        return Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: orderList
                .map((order) => OrderTile(
                      isOpen: true,
                      order: order,
                      cancelOrder: confirmCancel,
                    ))
                .toList(),
            // children: [
            //   ...for(var order in orderList){

            //      for(var productList in order)
            //      OrderTile(orderId: orderId, itemName: itemName, dateTime: dateTime, imageUrl: imageUrl, quantity: quantity)

            //   }
            // ],
            // children: orderList.map((order) {
            //   // print(order.data());
            //   String orderId = order.id;
            //   String dateTime = order['Date'];
            //   List items = order['Products Ordered'];

            //   return Column(
            //     children: items.map((e) {
            //       // return Row(
            //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       //   children: [Text(e['name']), Text(orderId)],
            //       // );

            //       return OrderProductTile(
            //         orderId: orderId,
            //         itemName: e['name'],
            //         dateTime: dateTime,
            //         imageUrl: e['image'],
            //         quantity: e['quantity'],
            //       );
            //     }).toList(),
            //   );
            // }).toList(),
          ),
        );
      }),
    );
  }
}
