import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/products_widget.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';

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
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isInMain && snapshot.data!.docs.length > 4
                  ? 4
                  : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ProductsWidget(
                  id: snapshot.data!.docs[index]['id'],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(18.0),
              child: Center(
                child: Text('Your store is empty'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        );
      },
    );
  }
}
