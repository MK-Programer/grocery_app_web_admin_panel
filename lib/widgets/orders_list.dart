import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/consts/constants.dart';
import 'package:grocery_app_web_admin_panel/widgets/orders_widget.dart';

class OrdersList extends StatelessWidget {
  final bool isInDashboard;
  const OrdersList({
    Key? key,
    this.isInDashboard = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                // color: Colors.red,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isInDashboard && snapshot.data!.docs.length > 5
                    ? 5
                    : snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var currentOrder = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      OrdersWidget(
                        price: currentOrder['price'],
                        totalPrice: currentOrder['totalPrice'],
                        productId: currentOrder['productId'],
                        userId: currentOrder['userId'],
                        imageUrl: currentOrder['imageUrl'],
                        userName: currentOrder['userName'],
                        quantity: currentOrder['quantity'],
                        orderDate: currentOrder['orderDate'],
                      ),
                      const Divider(
                        thickness: 3.0,
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(18.0),
              child: Center(
                child: Text('No orders found'),
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
