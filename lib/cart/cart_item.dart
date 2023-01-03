import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String price;
  final bool inStock;
  final Function removeProduct;

  const CartItem(
      {Key? key,
      required this.name,
      required this.imgUrl,
      required this.price,
      required this.inStock,
      required this.removeProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const currencySymb = 'Gh¢';
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(UniqueKey().toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      direction: DismissDirection.endToStart,
      dismissThresholds: {DismissDirection.endToStart: 0.8},
      onDismissed: (direction) {
        // Then show a snackbar.
      },
      // Show a red background as the item is swiped away.
      background: Container(
        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
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
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ListTile(
                trailing: Text('$currencySymb $price'),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(color: Colors.blue),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imgUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                          child: Text('in stock',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
