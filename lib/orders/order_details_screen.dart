import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Id:${order.id}',
          style: TextStyle(fontSize: 14),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
