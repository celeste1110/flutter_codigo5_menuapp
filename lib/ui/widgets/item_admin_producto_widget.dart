import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/product_form_page.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/product_model.dart';
import '../general/colors.dart';
import 'general_widget.dart';

class ItemAdminProductWidget extends StatelessWidget {
  ProductsModel productModel;
  List<CategoryModel> categories;
  ItemAdminProductWidget(
      {required this.productModel, required this.categories});
  final FirestoreService _productService=FirestoreService(collection: 'products');

  showAlertDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Eliminar producto"),
              divider3,
              TextNormal(
                  text:
                      "Estas seguro de eliminar el producto, ten presente que sera de forma permanente"),
              divider6,
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(

                        color: kBrandPrimaryColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  dividerWidth10,
                  ElevatedButton(
                    onPressed: () {
                      _productService.deleteProduct(productModel.id!).then((value) {
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      primary: kBrandPrimaryColor,
                    ),
                    child: Text('Aceptar'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.black26,
                backgroundImage: NetworkImage(productModel.image),
              ),
              dividerWidth10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: kBrandSecondaryColor.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        productModel.categoryDescription!,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    divider3,
                    Text(
                      productModel.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    divider3,
                    TextNormal(
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      color: kBrandPrimaryColor.withOpacity(.6),
                      text: productModel.description,
                    ),
                    divider6,
                    Row(
                      children: [
                        Text(
                            "S/ ${productModel.price.toStringAsFixed(2)}   |   ${productModel.time} min.")
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: -12,
            top: -10,
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              icon: Icon(
                Icons.more_vert,
                color: kBrandPrimaryColor.withOpacity(0.8),
              ),
              onSelected: (value) {
                if (value == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductFormPage(
                        categories: categories,
                        productsModel: productModel,
                      ),
                    ),
                  );
                } else if (value == 2) {
                  showAlertDelete(context);
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/edit.svg'),
                        dividerWidth6,
                        TextNormal(
                          text: "Actualizar",
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/trash.svg'),
                        dividerWidth6,
                        TextNormal(
                          text: "Eliminar",
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
