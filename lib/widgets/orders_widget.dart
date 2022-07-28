import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
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
                "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png",
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
                    text: "12x For \$19.9",
                    color: color,
                    textSize: 16.0,
                    isTitle: true,
                  ),
                  FittedBox(
                    child: Row(
                      children: [
                        TextWidget(
                          text: "By",
                          color: Colors.blue,
                          textSize: 16.0,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: " M. khaled",
                          color: color,
                          textSize: 14.0,
                          isTitle: true,
                        ),
                      ],
                    ),
                  ),
                  const Text("29/07/2022"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
