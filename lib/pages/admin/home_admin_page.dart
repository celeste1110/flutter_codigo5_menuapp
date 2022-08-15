import 'dart:math';

import 'package:flutter/material.dart';

import '../../ui/general/colors.dart';
import '../../ui/widgets/background_widget.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_menu_widget.dart';
import '../../ui/widgets/product_page.dart';
import '../../ui/widgets/text_widget.dart';
import 'category_page.dart';
import 'dashboard_page.dart';
import 'order_admin_page.dart';


class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          //Fondo

              BackgroundWidget(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        divider30,
                        TextNormal(
                          text: "Bienvenido",
                        ),
                        H1(
                          text: "Las espadas de Ramón",
                        ),
                        divider20,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextNormal(
                                text: "23 de Abril del 2022",
                                color: kBrandPrimaryColor.withOpacity(0.6),
                              ),
                              Text(
                                "#34",
                                style: TextStyle(
                                  color: kBrandPrimaryColor,
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextNormal(
                                text: "Cantidad de ordenes en el día",
                                color: kBrandPrimaryColor.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        divider20,
                        GridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: [
                            ItemMenuWidget(
                              text: "Ordenes",
                              img: "burger",
                              toPage: OrderAdminPage(),
                            ),
                            ItemMenuWidget(
                              text: "Productos",
                              img: "products",
                              toPage: ProductPage(),
                            ),
                            ItemMenuWidget(
                              text: "Categorías",
                              img: "category",
                              toPage: CategoryPage(),
                            ),
                            ItemMenuWidget(
                              text: "Reportes",
                              img: "dash",
                              toPage: DashboardPage(),
                            ),

                          ],
                        ),
                      ],
                    ),

              ),
                ),
          ),

        ],
      ),
    );
  }
}