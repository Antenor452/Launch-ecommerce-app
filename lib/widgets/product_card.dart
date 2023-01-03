import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/constants.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/product_detail.dart';
import 'package:provider/provider.dart';

import '../blocks/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final productDet;
  const ProductCard({Key? key, required this.id, required this.productDet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // imgUrl: product['imgUrl'],
    //               price: product['price'],
    //               imgList: product['images'],
    //               description: product['description'],
    final name = productDet['name'].toString().toUpperCase();
    final price = double.parse(productDet['price']);
    final imgUrl = productDet['imgUrl'];

    const currencySymb = 'Gh¢';

    Map product = {
      'id': id,
      'name': name,
      'ratings': 5.0,
      'image': imgUrl,
      'price': price,
      'quantity': 1
    };
    return Container(
      width: 140.0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    Products(id: id, product_details: productDet),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 160,
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imgUrl,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '$currencySymb ${currencyFormat.format(price)}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       elevation: 0,
                //       backgroundColor: Theme.of(context).primaryColor),
                //   onPressed: () {
                //     Provider.of<Cart>(context, listen: false)
                //         .addtoCart(product);
                //   },
                //   child: Consumer<Cart>(
                //     builder: (context, value, child) {
                //       return value.isInCart(product)
                //           ? Text('Added to Cart')
                //           : Text('Add to Cart');
                //     },
                //   ),
                // ),
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
                          : Text('Add to Cart'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
