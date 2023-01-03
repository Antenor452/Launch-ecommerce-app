import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';

import '../blocks/cart_provider.dart';

class Products extends StatelessWidget {
  final product_details;
  final String id;
  const Products({Key? key, required this.product_details, required this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = product_details['name'].toString().toUpperCase();
    final price = currencyFormat.format(
      double.parse(product_details['price']),
    );
    final description = product_details['description'];
    final List images = product_details['images'];

    Map product = {
      'id': id,
      'name': name,
      'ratings': 5.0,
      'image': images.first,
      'price': price,
      'quantity': 1
    };
    const currencySymb = 'Gh¢';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$name',
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            top: false,
            left: false,
            right: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: Hero(
                      tag: id,
                      child: CarouselSlider(
                        items: images.map((imageUrl) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              '$name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 10.0),
                                  //   child: Text(
                                  //     '\$90',
                                  //     style: TextStyle(
                                  //       color: Theme.of(context).primaryColor,
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //   ),
                                  // ),
                                  Text('$currencySymb $price',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  RatingStars(
                                    value: 2.2,
                                    starSize: 16,
                                    valueLabelColor: Colors.amber,
                                    starColor: Colors.amber,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment(-1.0, -1.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            Container(
                                alignment: Alignment(-1.0, -1.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    "$description",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Consumer<Cart>(
                builder: (context, value, child) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: value.isInCart(id)
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                      onPressed: () {
                        if (!value.isInCart(id)) {
                          value.addtoCart(product);
                        }
                      },
                      child: value.isInCart(id)
                          ? Text('Added to Cart')
                          : Text('Add to Cart'));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
