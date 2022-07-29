import 'package:flutter/material.dart';
import 'package:grocery_app_web_admin_panel/inner_screens/add_products.dart';
import 'package:grocery_app_web_admin_panel/responsive.dart';
import 'package:grocery_app_web_admin_panel/services/global_method.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/buttons.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/menu_controller.dart';
import '../widgets/grid_product.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                context.read<MenuController>().controlDashboarkMenu();
              },
              title: 'Dashboard',
            ),
            const SizedBox(height: 20.0),
            TextWidget(
              text: "Latest Products",
              color: color,
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                    onPressed: () {},
                    text: "View All",
                    icon: Icons.store,
                    backgroundColor: Colors.blue,
                  ),
                  const Spacer(),
                  ButtonsWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadProductForm(),
                        ),
                      );
                    },
                    text: "Add product",
                    icon: Icons.add,
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // MyProductsHome(),
                      // SizedBox(height: defaultPadding),
                      // OrdersScreen(),
                      Responsive(
                        mobile: ProductGrid(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGrid(
                          crossAxisCount: 4,
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OrdersList(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
