import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/cart_provider.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/product_grid.dart';

import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  final String id;
  final String name;
  const CategoryScreen({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (MediaQuery.of(context).size.height / 2) - 20;
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      floatingActionButton: Consumer<Cart>(
        builder: (context, value, child) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            child: Badge(
              toAnimate: false,
              badgeContent: Text(
                value.cart.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
            backgroundColor: Colors.blueAccent,
          );
        },
      ),
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            db.collection('products').where('category', isEqualTo: id).get(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error connecting to server'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.size == 0) {
            return Center(
                child: const Text('Sorry No Items Available at the moment'));
          }
          final List<QueryDocumentSnapshot> itemList = snapshot.data!.docs;

          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight),
            children: itemList.map((item) {
              return ProductGrid(
                productId: item.id,
                productDetails: item.data(),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
