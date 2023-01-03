import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';

class OrderProductTile extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final int quantity;
  final double price;

  const OrderProductTile(
      {Key? key,
      required this.itemName,
      required this.imageUrl,
      required this.quantity,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            itemName,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Unit Price : $currencySymb ${currencyFormat.format(price)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Quantity:  X$quantity',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Text(
                        '$currencySymb ${currencyFormat.format(price * quantity)}',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
