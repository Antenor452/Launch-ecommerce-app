import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/categories/category.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    CollectionReference categoryRef = db.collection("categories");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Text('Shop By Category',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child:
                      Text('View All', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/categorise');
                  }),
            )
          ],
        ),
        Container(
          // child: GridView.count(
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     crossAxisCount: 2,
          //     padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
          //     children: []),
          child: FutureBuilder<QuerySnapshot>(
            future: categoryRef.limit(4).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Could not connect to server '),
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
                return Center(
                  child: Column(
                    children: [
                      Text('No entries yet Check back later'),
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Text('Tap to Refresh'),
                      )
                    ],
                  ),
                );
              }
              final List categoryList = snapshot.data!.docs;
              return GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: const EdgeInsets.only(
                    top: 8, left: 6, right: 6, bottom: 12),
                children: categoryList.map((category) {
                  String id = category.id;

                  return CategoryGrid(
                      id: id,
                      name: category['name'],
                      imgUrl: category['imgUrl']);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  const CategoryGrid(
      {Key? key, required this.name, required this.imgUrl, required this.id})
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
                  name: name,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: (MediaQuery.of(context).size.width / 2) - 70,
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
                name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
