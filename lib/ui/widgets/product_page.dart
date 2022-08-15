import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/product_form_page.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../general/colors.dart';
import 'floating_button_widget.dart';
import 'general_widget.dart';
import 'item_admin_producto_widget.dart';
import 'my_appbar_widget.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final CollectionReference _productReference =
  FirebaseFirestore.instance.collection('products');
  final FirestoreService _categoryReference =
  FirestoreService(collection: "categories");
  final FirestoreService _productService=FirestoreService(collection: 'products');

  List<CategoryModel> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();


  }

  getData() async{
    categories = await _categoryReference.getCategories();
    setState(() {

    });

    print(categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(
          text: "Productos",
        ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onTap: (){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductFormPage(
              categories: categories,

            ),
          ),
        );
        },

      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: _productService.getStreamProduct(),
              builder: (BuildContext context, AsyncSnapshot snap) {
                if (snap.hasData) {
                  QuerySnapshot collection = snap.data;
                  List<ProductsModel> products = collection.docs.map((e) {
                    ProductsModel product =
                    ProductsModel.fromJson(e.data() as Map<String, dynamic>);
                    product.id = e.id;

                    product.categoryDescription=categories.isNotEmpty?categories.firstWhere((element) => element.id==product.categoryId).category:'';

                    return product;
                  }).toList();
                  //String categoryDescription='';

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {

                      return ItemAdminProductWidget(
                        productModel: products[index],
                        categories: categories,
                      );
                    },
                  );
                }
                return LoadingWidget();
              },
            ),
            divider40,
            divider40,
          ],
        ),
      )
    );
  }
}