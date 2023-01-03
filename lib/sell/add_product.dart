import 'dart:io';
import 'package:path/path.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/services/cloud_services.dart';
import 'package:flutter_ecommerce_ui_kit/services/firestore_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  final _formkey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final desController = TextEditingController();
  List categories = ['Select a category'];
  List imgPaths = [];

  String category = 'Select a category';
  getCategories() async {
    print('start');
    var results = await db.collection('categories').get();

    results.docs.forEach((category) {
      categories.add(category['name']);
    });
    setState(() {});
  }

  Future getImage() async {
    final image = await ImagePicker().pickMultiImage();
    if (image == null) {
      Fluttertoast.showToast(msg: 'Image not selected');
      return null;
    }
    final imgPath = image.map((image) => image.path);
    setState(() {
      imgPaths.addAll(imgPath);
    });
  }

  clearAll() {
    setState(() {
      nameController.clear();
      priceController.clear();
      desController.clear();
      imgPaths.clear();
    });
  }

  uploadProduct(cat) async {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.unfocus();
    // }
    if (_formkey.currentState!.validate()) {
      if (imgPaths.isEmpty) {
        Fluttertoast.showToast(msg: 'Please add an image');
        return null;
      }
      if (category == 'Select a category') {
        Fluttertoast.showToast(msg: 'Please select a valid category');
        return null;
      }
    }
    try {
      var productId;
      Future<List> imgUrls;
      QuerySnapshot category =
          await db.collection('categories').where('name', isEqualTo: cat).get();
      var catId = category.docs.first.id;
      db.collection('products').add({
        'category': catId,
        'name': nameController.text,
        'description': desController.text,
        'price': priceController.text,
      }).then((docRef) async {
        imgUrls = Future.wait(imgPaths.map((imagePath) async {
          final fileName = basename(imagePath);
          File file = File(imagePath);

          var uploadRef = await productsImageRef
              .child(docRef.id)
              .child(fileName)
              .putFile(file);
          String url = await uploadRef.ref.getDownloadURL();

          return url;
        }).toList())
            .then((urlList) {
          db
              .collection('products')
              .doc(docRef.id)
              .update({'imgUrl': urlList.first, 'images': urlList});
          Fluttertoast.showToast(msg: 'Product added successfully');
          return urlList;
        });
      });

      print('worked');
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell a product'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                imgPaths.length > 0
                    ? Container(
                        height: 420,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            CarouselSlider(
                              items: imgPaths.map((image) {
                                return Image.file(File(image));
                              }).toList(),
                              options: CarouselOptions(
                                height: 350,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imgPaths.length,
                                  itemBuilder: (context, index) {
                                    print(index);
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          imgPaths.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 12, right: 10),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.5),
                                                BlendMode.darken),
                                            image: FileImage(
                                              File(imgPaths[index]),
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text('Add Photo'),
                    ),
                    InkWell(
                      onTap: getImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.primary),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 12),
                    child: DropdownButton<String>(
                        hint: Text('Product Category'),
                        isExpanded: true,
                        value: category,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            category = value.toString();
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList())),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a name for the product';
                      }
                    },
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: desController,
                    validator: (value) {
                      if (value == null || value.length < 50) {
                        return 'Please enter a product description of valid lenght';
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 200,
                    decoration:
                        InputDecoration(labelText: 'Product Description'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter an amount in cedis';
                      }
                      if (double.parse(value.toString()) <= 0) {
                        return 'Please enter an amount greater than 0';
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    decoration: InputDecoration(labelText: 'Product Price'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      uploadProduct(category);
                    },
                    child: Text('Upload Product'),
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

class ImageContainer extends StatelessWidget {
  final String path;
  const ImageContainer({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Center(
          child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: new AssetImage(path))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                print('remove ');
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
      )),
    );
  }
}
