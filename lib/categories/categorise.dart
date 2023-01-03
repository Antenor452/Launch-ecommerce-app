import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_ecommerce_ui_kit/categories/category.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';

class Categorise extends StatefulWidget {
  @override
  _CategoriseState createState() => _CategoriseState();
}

class _CategoriseState extends State<Categorise> {
  CollectionReference catRef = db.collection("categories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: catRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.data!.size == 0) {
                return Center(
                  child: Text("Empty"),
                );
              }
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                children: documents.map((category) {
                  return CategoryContainer(
                      id: category.id,
                      categoryName: category['name'],
                      imgUrl: category['imgUrl']);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String id;
  final String imgUrl;
  final String categoryName;
  const CategoryContainer(
      {Key? key,
      required this.categoryName,
      required this.imgUrl,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryScreen(
                  id: id,
                  name: categoryName,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 180,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imgUrl,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              ListTile(
                  title: Text(
                categoryName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
