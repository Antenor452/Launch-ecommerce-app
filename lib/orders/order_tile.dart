import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';
import 'package:flutter_ecommerce_ui_kit/orders/order_details_screen.dart';
import 'package:flutter_ecommerce_ui_kit/orders/product_order_tile.dart';

class OrderTile extends StatelessWidget {
  final QueryDocumentSnapshot order;
  final bool isOpen;
  final Function? cancelOrder;
  OrderTile(
      {Key? key, required this.order, this.cancelOrder, required this.isOpen})
      : super(key: key);

  formatDate(String date) {
    var dateTime = DateTime.parse(date);
    String dateSlug =
        '${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}';
    return dateSlug;
  }

  @override
  Widget build(BuildContext context) {
    String orderId = order.id;
    Timestamp dateTime = order['Date'];
    List products = order['Products Ordered'];
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => OrderDetailScreen(
        //             order: order,
        //           )),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: $orderId',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Order Time: ${formatDate(dateTime.toDate().toIso8601String())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Text(
                      '${order['Progress']}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Column(
                  children: products.map((product) {
                return OrderProductTile(
                  itemName: product['name'],
                  imageUrl: product['image'],
                  quantity: product['quantity'],
                  price: double.parse(product['price'].toString()),
                );
              }).toList()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total '),
                Text(
                    '$currencySymb ${currencyFormat.format(order['TotalAmount'])}'),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            isOpen
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size.fromHeight(40),
                    ),
                    onPressed: () {
                      cancelOrder!(orderId);
                    },
                    child: Text('Cancel Order'),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 2,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
