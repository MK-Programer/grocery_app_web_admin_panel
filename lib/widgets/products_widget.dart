import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png",
                        fit: BoxFit.fill,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () {},
                            value: 1,
                            child: const Text("Edit"),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            value: 2,
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: "\$1.99",
                      color: color,
                      textSize: 18.0,
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Visibility(
                      visible: true,
                      child: Text(
                        "\$3.89",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextWidget(
                      text: "1Kg",
                      color: color,
                      textSize: 18.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                TextWidget(
                  text: "Title",
                  color: color,
                  textSize: 24.0,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
