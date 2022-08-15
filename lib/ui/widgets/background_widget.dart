import 'dart:math';

import 'package:flutter/material.dart';

import '../general/colors.dart';
import 'general_widget.dart';


class BackgroundWidget  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return  Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -height * 0.2,
          child: Transform.rotate(
            angle: pi / 4.5,
            child: Container(
              height: height * 0.65,
              width: height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120.0),
                gradient: LinearGradient(
                  colors: [
                    kBrandSecondaryColor,
                    const Color(0xff2ec4b6),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -40,
          top: -10.0,
          child: circleWidget(
            100.0,
          ),
        ),
        Positioned(
          right: -width * 0.22,
          top: 10.0,
          child: circleWidget(
            120.0,
          ),
        ),
      ],
    );
  }
}