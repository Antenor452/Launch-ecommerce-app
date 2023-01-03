import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../blocks/cart_provider.dart';

class ProductGrid extends StatelessWidget {
  final productId;
  final productDetails;
  const ProductGrid(
      {Key? key, required this.productId, required this.productDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = productDetails['name'].toString().toUpperCase();
    final price = currencyFormat.format(
      double.parse(productDetails['price']),
    );
    final imgUrl = productDetails['imgUrl'];
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: (MediaQuery.of(context).size.width / 2),
                      width: double.infinity,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imgUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      currencySymb + price,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RatingStars(
                      value: 3,
                      starCount: 5,
                      valueLabelVisibility: false,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Consumer<Cart>(
                  builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: value.isInCart(productId)
                          ? Colors.grey
                          : Colors.deepOrange,
                      minimumSize: Size.fromHeight(30),
                    ),
                    onPressed: () {},
                    child: value.isInCart(productId)
                        ? Text('Item Added to Cart')
                        : Text("Add to Cart"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
