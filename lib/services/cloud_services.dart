import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();
final profileRef = storageRef.child('profileImages');
final productsImageRef = storageRef.child('productImages');
