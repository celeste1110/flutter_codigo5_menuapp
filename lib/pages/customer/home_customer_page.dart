import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../ui/general/colors.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_category_widget.dart';
import '../../ui/widgets/item_product_widget.dart';
import '../../ui/widgets/item_promotion_widget.dart';
import '../../ui/widgets/search_widget.dart';
import '../../ui/widgets/text_widget.dart';
import '../../utils/search_product_delegate.dart';

class HomeCustomerPage extends StatefulWidget {
  const HomeCustomerPage({Key? key}) : super(key: key);

  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  final FirestoreService _productService =
      FirestoreService(collection: 'products');
  final FirestoreService _categoryService =
      FirestoreService(collection: 'categories');

  List<ProductsModel> products = [];
  List<ProductsModel> productsAux = [];
  List<CategoryModel> categories = [];
  List<ProductsModel> products2 = [];
  int indexCategory = 0;
  bool isLoading = true;
  
 final SPGlobal _prefs=SPGlobal();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFirebase();

    // _prefs.isLogin = false;
  }

  getDataFirebase() async {
    categories = await _categoryService.getCategories();
    products = await _productService.getProducts();
    products=products.map((e) {
      String categoryDescription=categories.firstWhere((element) => element.id==e.categoryId).category;
    e.categoryDescription=categoryDescription;
      return e;
    }).toList();



    productsAux = products;


    categories.insert(
      0,
      CategoryModel(
        id: '0',
        category: 'Todos',
        status: true,
      ),
    );
    products2 = products.where((element) => element.discount > 0).toList();
    isLoading = false;
    //print(_prefs.fullName.indexOf(' '));
    setState(() {});
  }

  getFiltro(String categoryId) {
    products = productsAux;
    if (categoryId != '0') {
      products = products
          .where((element) => element.categoryId == categoryId)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading ?  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider12,
                TextNormal(
                  //text: 'Bienvenido',
                  //text: "Bienvenidos, ${_prefs.fullName.substring(0,_prefs.fullName.indexOf('e'))}",
                  text: "Bienvenidos, ${_prefs.fullName}",
                ),
                H1(
                  text: "Las espadas de Ramón",
                ),
                divider12,
                SearchWidget(

                  onTap: () async {
                    final res = await showSearch(
                      context: context,
                      delegate: SearchProductDelegate(
                        products: productsAux,
                      ),
                    );
                    print(res);
                  },
                ),
                divider12,
                TextNormal(
                  text: "Promociones",
                ),
                divider12,
                SizedBox(
                  height: 260.0,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: products2.length,
                    controller: PageController(
                      initialPage: 0,
                      viewportFraction: 0.8,
                    ),
                    padEnds: false,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemPromotionWidget(
                        productModel: products2[index],
                      );
                    },
                  ),
                ),
                divider20,
                TextNormal(
                  text: "Categorías",
                ),
                divider20,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: categories
                        .map(
                          (e) => ItemCategoryWidget(
                            text: e.category,
                            selected: indexCategory == categories.indexOf(e),
                            onTap: () {
                              indexCategory = categories.indexOf(e);
                              getFiltro(e.id!);
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                divider20,
                products.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemProductWidget(
                            productModel: products[index],
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/box.png',
                              height: 100,
                            ),
                            divider6,
                            TextNormal(
                                text: 'Aun no hay productos en esta categoria')
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ):Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: kBrandSecondaryColor,
          ),
        ),
      ),
    );
  }
}
