import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/button_normal_widget.dart';
import 'package:flutter_codigo5_menuapp/utils/constans.dart';

import '../../models/order_model.dart';
import '../../services/firestore_service.dart';
import '../general/colors.dart';
import 'general_widget.dart';

class DialogOrderDetailWidget extends StatefulWidget {
  OrderModel orderModel;

  DialogOrderDetailWidget({required this.orderModel});

  @override
  State<DialogOrderDetailWidget> createState() =>
      _DialogOrderDetailWidgetState();
}

class _DialogOrderDetailWidgetState extends State<DialogOrderDetailWidget> {
  final FirestoreService _orderService =
  FirestoreService(collection: "orders");
  String statusValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusValue = widget.orderModel.status;
  }
  void updateStatus(){
    widget.orderModel.status = statusValue;
    _orderService.updateStatusOrder(widget.orderModel).whenComplete((){
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    print(statusColor.entries.map((e) => e.key).map((e) => e).toList());
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Detalle de la orden",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 0.2,
            ),
            divider6,
            Text(
              'Cliente',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.8),
              ),
            ),
            Text(
              widget.orderModel.customer,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.6),
              ),
            ),
            divider3,
            Text(
              'Fecha / Hora',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.6),
              ),
            ),
            Text(
              widget.orderModel.datetime,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.6),
              ),
            ),
            divider3,
            Divider(
              thickness: 0.2,
            ),
            Text(
              'Productos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.8),
              ),
            ),
            divider3,
            ...widget.orderModel.products
                .map(
                  (e) => Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: kBrandPrimaryColor.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                "S/${e.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: kBrandPrimaryColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Cant. ${e.quantity}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0,
                            color: kBrandPrimaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            divider3,
            Divider(
              thickness: 0.2,
            ),
            Text(
              'Estado',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kBrandPrimaryColor.withOpacity(0.8),
              ),
            ),
            // Wrap(
            //   spacing: 10,
            //   children: [
            //     FilterChip(
            //         label: Text(
            //           'Recibido',
            //           style: TextStyle(
            //             fontSize: 13,
            //
            //           ),
            //         ),
            //         onSelected: (bool value) {}),
            //     FilterChip(
            //         label: Text(
            //           'En proceso',
            //           style: TextStyle(
            //             fontSize: 13,
            //
            //           ),
            //         ),
            //         onSelected: (bool value) {}),
            //     FilterChip(
            //         label: Text(
            //           'Finalizado',
            //           style: TextStyle(
            //             fontSize: 13,
            //
            //           ),
            //         ),
            //         onSelected: (bool value) {}),
            //   ],
            // )
            Wrap(
              children: statusColor
                  .map((key, value) => MapEntry(key, value))
                  .keys
                  .map(
                    (e) => FilterChip(
                      selected: statusValue == e,
                      selectedColor: statusColor[statusValue],
                      checkmarkColor:
                          statusValue == e ? Colors.white : Colors.black38,
                      label: Text(
                        e,
                        style: TextStyle(
                          fontSize: 13.0,
                          color:
                              statusValue == e ? Colors.white : Colors.black38,
                        ),
                      ),
                      onSelected: (bool value) {
                        statusValue = e;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            divider3,
            Divider(
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: kBrandPrimaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                dividerWidth10,
                ElevatedButton(
                  onPressed: () {
                    updateStatus();



                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                  child: Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
