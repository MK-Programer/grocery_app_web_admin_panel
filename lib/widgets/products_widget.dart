import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';

import '../services/global_method.dart';

class ProductsWidget extends StatefulWidget {
  final String id;
  const ProductsWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  String title = 'Title';
  String productCat = 'Product Category';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    super.initState();
    getProductsData();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productDoc == null) {
        return;
      } else {
        setState(() {
          title = productDoc.get('title');
          productCat = productDoc.get('productCategoryName');
          imageUrl = productDoc.get('imageUrl');
          price = productDoc.get('price');
          salePrice = productDoc.get('salePrice');
          isOnSale = productDoc.get('isOnSale');
          isPiece = productDoc.get('isPiece');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(subTitle: '$error', context: context);
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        imageUrl ??
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
                      text: isOnSale
                          ? "\$${salePrice.toStringAsFixed(2)}"
                          : "\$$price",
                      color: color,
                      textSize: 18.0,
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Visibility(
                      visible: isOnSale,
                      child: Text(
                        "\$$price",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextWidget(
                      text: isPiece ? "Piece" : "1Kg",
                      color: color,
                      textSize: 18.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                TextWidget(
                  text: title,
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
