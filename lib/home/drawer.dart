import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/auth_provider.dart';
import 'package:provider/provider.dart';
import '../blocks/cart_provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);

    return Column(
      children: <Widget>[
        if (auth.isLoggedIn)
          Consumer<AuthBlock>(
            builder: (context, value, child) {
              final bool hasProfile = value.user!.imgUrl != null;

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: hasProfile
                      ? NetworkImage(auth.user!.imgUrl.toString())
                      : NetworkImage(
                          'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'),
                ),
                accountEmail: Text(value.user!.email.toString()),
                accountName: Text(value.user!.username ?? ''),
              );
            },
          ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Shop'),
                trailing: Text('New',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/shop');
                },
              ),
              ListTile(
                leading: Icon(Icons.category,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Categories'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categorise');
                },
              ),
              // ListTile(
              //   leading:
              //       Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary),
              //   title: Text('My Wishlist'),
              //   trailing: Container(
              //     padding: const EdgeInsets.all(10.0),
              //     decoration: new BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Theme.of(context).primaryColor,
              //     ),
              //     child: Text('4',
              //         style: TextStyle(color: Colors.white, fontSize: 10.0)),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.pushNamed(context, '/wishlist');
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('My Cart'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Consumer<Cart>(
                    builder: (context, value, child) {
                      return Text(
                        value.cart.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      );
                    },
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              auth.isLoggedIn
                  ? ListTile(
                      leading: Icon(
                        Icons.list_alt_sharp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text('Orders'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/orders');
                      },
                    )
                  : Container(),
              auth.isLoggedIn
                  ? ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text('Sell a product'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/addProduct');
                      },
                    )
                  : Container(),
              !auth.isLoggedIn
                  ? ListTile(
                      leading: Icon(Icons.lock,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Login'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/auth');
                      },
                    )
                  : Container(),
              Divider(),
              auth.isLoggedIn
                  ? ListTile(
                      leading: Icon(Icons.settings,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/settings');
                      },
                    )
                  : Container(),
              auth.isLoggedIn
                  ? ListTile(
                      leading: Icon(Icons.exit_to_app,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Logout'),
                      onTap: () async {
                        auth.logout();
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
