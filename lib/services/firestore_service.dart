import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/models/order_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';

import '../models/user_model.dart';

class FirestoreService{
  final String collection;
  FirestoreService({required this.collection});
  late final CollectionReference _collectionReference=FirebaseFirestore.instance.collection(collection);

 Stream  getStreamCategory() {
    return _collectionReference.orderBy('category').snapshots();
  }
  Stream getStreamProduct(){
    return _collectionReference.orderBy('name').snapshots();
  }

  Stream getStreamOrder(){
    return _collectionReference.orderBy('datetime').snapshots();
  }



  Future<List<ProductsModel>>getProducts() async{
    List<ProductsModel> products=[];
    QuerySnapshot _querySnapshot= await _collectionReference.get();
    _querySnapshot.docs.forEach((element) {
      // Map<String,dynamic> product =element.data() as Map<String,dynamic>;
      // product['id']=element.id;

      ProductsModel productModel=ProductsModel.fromJson(element.data() as Map<String,dynamic>);
      productModel.id=element.id;
      products.add(productModel);
    });
  //print(products);
    return products;

  }
  Future<List<CategoryModel>>getCategories()async{
    List<CategoryModel> categories=[];

    QuerySnapshot _querySnapshot= await _collectionReference.get();
    _querySnapshot.docs.forEach((element) {
  CategoryModel categorieModel=CategoryModel.fromJson(element.data() as Map<String,dynamic>);
  categorieModel.id=element.id;
  categories.add(categorieModel);
  });

    return categories;

  }
  Future<String> addProduct(ProductsModel productsModel) async {
    DocumentReference documentReference=await _collectionReference.add(
      productsModel.toJson()
    );
    return documentReference.id;

  }

Future <int> updateProduct(ProductsModel productsModel) async {
   await  _collectionReference.doc(productsModel.id).update(productsModel.toJson());
   return 1;
}
  Future <int> deleteProduct(String id) async {
    await  _collectionReference.doc(id).delete();
    return 1;
  }
  Future<String> addUser(UserModel userModel) async{
  try{
    DocumentReference documentReference = await _collectionReference.add(userModel.toJson());
    return documentReference.id;
  } on TimeoutException catch(e){
    return Future.error('error 1');
  } on SocketException catch(e){
    return Future.error('error 2');
  }on Error catch(e){
    return Future.error('error 3');
  }
}
  Future<UserModel?> getUser(String email) async{
    QuerySnapshot querySnapshot = await _collectionReference.where('email', isEqualTo: email).get();
    if(querySnapshot.docs.isNotEmpty){
      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      UserModel userModel = UserModel.fromJson(queryDocumentSnapshot.data() as Map<String, dynamic>);
      userModel.id  = queryDocumentSnapshot.id;
      print(userModel.toJson());
      return userModel;
    }
    return null;
  }

  Future<String>addOrder(OrderModel orderModel) async{
    DocumentReference documentReference = await _collectionReference.add(orderModel.toJson());
    return documentReference.id;
  }

  Future<int> updateStatusOrder(OrderModel model) async{
    _collectionReference.doc(model.id).update(
      {
        "status": model.status,
      },
    );
    return 1;
  }
}