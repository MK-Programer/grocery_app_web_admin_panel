import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/widgets/products_widget.dart';

import '../consts/constants.dart';

class ProductGrid extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  const ProductGrid({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.isInMain = true,
  }) : super(key: key);
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: isInMain ? 4 : 20,
      itemBuilder: (context, index) {
        return const ProductsWidget();
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
      ),
    );
  }
}
