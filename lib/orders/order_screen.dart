import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/orders/closed_order_screen.dart';
import 'package:flutter_ecommerce_ui_kit/orders/open_order_screen.dart';
import 'package:flutter_ecommerce_ui_kit/orders/tab_controller.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int activeIndex = 0;

  void updateIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  List<Widget> tabScreens = [
    const OpenOrderScreen(),
    const ClosedOrderScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          elevation: 0,
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabNavBar(
                activeIndex: activeIndex,
                updateIndex: updateIndex,
              ),
              tabScreens[activeIndex]
            ],
          ),
        ));
  }
}

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
