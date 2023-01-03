import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/cart_provider.dart';
import 'package:flutter_ecommerce_ui_kit/localizations.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/categories.dart';
import 'package:flutter_ecommerce_ui_kit/widgets/new_arrivals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void currencyName() {
    Locale locale = Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: locale.toString(), name: "GHC");
    print("${format.currencySymbol}");
    print("${format.currencyName}");
  }

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
            // Add the app bar and list of items as slivers in the next steps.
            slivers: <Widget>[
              SliverAppBar(
                // Provide a standard title.
                title: Text('Launch'),
                pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Consumer<Cart>(
                      builder: (context, value, child) {
                        return Badge(
                          badgeContent: Text(
                            value.cart.length.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          showBadge: value.cart.length > 0,
                          child: Icon(Icons.shopping_cart),
                        );
                      },
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  )
                ],
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                // floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: HomeSlider(),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 300,
              ),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(
                      //   child: Padding(
                      //     padding:
                      //         EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
                      //     child: Image(
                      //       fit: BoxFit.cover,
                      //       image: NetworkImage(
                      //           'https://www.dbramante1928.com/media/179545/web_hero_banner_en.jpg'),
                      //     ),
                      //   ),
                      // ),
                      NewArrivals(),
                      Categories(),
                      // Container(
                      //   child: Padding(
                      //     padding: EdgeInsets.only(
                      //         top: 6.0, left: 8.0, right: 8.0, bottom: 10),
                      //     child: Image(
                      //       fit: BoxFit.cover,
                      //       image: AssetImage('assets/images/banner-2.png'),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              )
            ]),
      ),
    );
  }
}
