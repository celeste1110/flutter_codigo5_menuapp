import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../general/colors.dart';

class ButtonNormalWidger extends StatelessWidget {
String text;
Function onPressed;
String icon;
Color? color;

ButtonNormalWidger({required this.text, required this.onPressed,required this.icon,this.color});
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          onPressed();
          //uploadImageStorage();
        },
        style: ElevatedButton.styleFrom(
            primary: color ?? kBrandPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        icon: SvgPicture.asset(
          'assets/icons/$icon.svg',
          color: Colors.white,
        ),
        label: Text(
          text,
        ),
      ),
    );
  }
}
