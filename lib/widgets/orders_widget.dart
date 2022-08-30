import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';

class OrdersWidget extends StatefulWidget {
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;
  const OrdersWidget({
    Key? key,
    required this.price,
    required this.totalPrice,
    required this.productId,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.quantity,
    required this.orderDate,
  }) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateStr;
  @override
  void initState() {
    orderDateStr =
        '${widget.orderDate.toDate().day}/${widget.orderDate.toDate().month}/${widget.orderDate.toDate().year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: size.width < 650 ? 3 : 1,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text:
                        "${widget.quantity}x For \$${widget.price.toStringAsFixed(2)}",
                    color: color,
                    textSize: 16.0,
                    isTitle: true,
                  ),
                  FittedBox(
                    child: Row(
                      children: [
                        TextWidget(
                          text: "By ",
                          color: Colors.blue,
                          textSize: 16.0,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: widget.userName,
                          color: color,
                          textSize: 14.0,
                          isTitle: true,
                        ),
                      ],
                    ),
                  ),
                  Text(orderDateStr),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
