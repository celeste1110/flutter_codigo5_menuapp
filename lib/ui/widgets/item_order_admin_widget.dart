import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import 'package:flutter_codigo5_menuapp/utils/constans.dart';

import '../../models/order_model.dart';
import '../general/colors.dart';
import 'dialod_order_detail.dart';
import 'general_widget.dart';

class ItemOrderAdminWidget extends StatelessWidget {
  OrderModel orderModel;

  ItemOrderAdminWidget({
    required this.orderModel,
  });

  showDetailOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogOrderDetailWidget(orderModel: orderModel,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDetailOrder(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(4, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: ListTile(
          title: TextNormal(
            text: orderModel.customer,
          ),
          subtitle: Text(
            orderModel.datetime,
            style: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                    color: statusColor[orderModel.status],
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text(
                  orderModel.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
              divider3,
              Text(
                "Cant: ${orderModel.products.length.toString()}",
                style: TextStyle(
                  fontSize: 13.0,
                  color: kBrandPrimaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
