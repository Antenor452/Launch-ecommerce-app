import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/product_card.dart';

import '../localizations.dart';

class NewArrivals extends StatefulWidget {
  const NewArrivals({Key? key}) : super(key: key);

  @override
  State<NewArrivals> createState() => _NewArrivalsState();
}

class _NewArrivalsState extends State<NewArrivals> {
  @override
  Widget build(BuildContext context) {
    CollectionReference products = db.collection('products');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 14.0, left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  AppLocalizations.of(context)!.translate('NEW_ARRIVALS') ?? '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(Icons.refresh))
            ],
          )),
      Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 260.0,
        child: FutureBuilder<QuerySnapshot>(
          future: products.limit(10).get(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error connecting to server'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.data!.size == 0) {
              return Center(child: const Text('Sorry no new items'));
            }
            final List<QueryDocumentSnapshot> newArrivals = snapshot.data!.docs;
            return ListView(
              scrollDirection: Axis.horizontal,
              children: newArrivals.map((product) {
                return ProductCard(
                  id: product.id,
                  productDet: product.data(),
                );
              }).toList(),
            );
          },
        ),
      ),
    ]);
  }
}
