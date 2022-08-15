import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import 'general_widget.dart';

class ItemMenuWidget extends StatelessWidget {
  String text;
  String img;
  Widget toPage;

  ItemMenuWidget({
    required this.text,
    required this.img,
    required this.toPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> toPage));
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
          width: 74,
          height: 74,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/$img.png',
          ),
            ),
        divider12,
        TextNormal(
          text: text,
            ),
        ],
    ),
      ),
    );
  }
}
