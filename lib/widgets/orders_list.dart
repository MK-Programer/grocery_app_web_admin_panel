import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/consts/constants.dart';
import 'package:grocery_app_web_admin_panel/widgets/orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: const [
              OrdersWidget(),
              Divider(
                thickness: 3.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
