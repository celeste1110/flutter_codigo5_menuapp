import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/pages/customer/profile_page.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/order_stream_service.dart';
import '../../ui/general/colors.dart';
import 'home_customer_page.dart';
import 'order_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);
  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeCustomerPage(),
    // Center(
    //   child: Text(
    //     "Favoritos1",
    //   ),
    // ),
  OrderPage(),
    Center(
      child: Text(
        "Favoritos",
      ),
    ),
    ProfilePage(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    OrderStreamService().closeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 13.0),
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedItemColor: kBrandSecondaryColor,
        onTap: (int value) {
          _currentIndex = value;
          setState((){});
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: _currentIndex == 0 ? kBrandSecondaryColor : kBrandPrimaryColor.withOpacity(0.85),
            ),
          ),
          BottomNavigationBarItem(
            label: "Ordenes",
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/icons/shopping.svg',
                  color: _currentIndex == 1
                      ? kBrandSecondaryColor
                      : kBrandPrimaryColor.withOpacity(0.85),
                ),
                Positioned(
                  right: -3,
                  top: -3,
                  child: StreamBuilder(
                    stream: OrderStreamService().counterStream,
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        int counter = snap.data;
                        return counter > 0 ? Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kBrandSecondaryColor,
                          ),
                          child: Text(
                            counter.toString(),
                            style: TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ): const SizedBox();
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: "Favoritos",
            icon: SvgPicture.asset(
              'assets/icons/heart.svg',
              color: _currentIndex == 2 ? kBrandSecondaryColor : kBrandPrimaryColor.withOpacity(0.85),
            ),
          ),
          BottomNavigationBarItem(
            label: "Mi perfil",
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
              color: _currentIndex == 3 ? kBrandSecondaryColor : kBrandPrimaryColor.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}