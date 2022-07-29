import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app_web_admin_panel/responsive.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/buttons.dart';
import 'package:grocery_app_web_admin_panel/widgets/side_menu.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../widgets/header.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = "/UploadProductForm";
  const UploadProductForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _priceController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _uploadForm() {
    final isValid = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );

    return Scaffold(
      key: context.read<MenuController>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Header(
                      fct: () {
                        context.read<MenuController>().controlAddProductsMenu();
                      },
                      title: 'Add Product',
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    width: size.width > 650 ? 650 : size.width,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            text: "Product title*",
                            color: color,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey("Title"),
                            validator: (value) {
                              value!.isEmpty ? "Please, enter a title" : null;
                            },
                            decoration: inputDecoration,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: "Price in \$*",
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      SizedBox(
                                        width: 100.0,
                                        child: TextFormField(
                                          controller: _priceController,
                                          key: const ValueKey("Price \$"),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            value!.isEmpty
                                                ? "Price is missed"
                                                : null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]'),
                                            ),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      TextWidget(
                                        text: "Product category*",
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10.0),
                                      // ToDo: Implement the combobox
                                      const SizedBox(height: 20.0),
                                      TextWidget(
                                        text: "Measuring unit",
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10.0),
                                      // ToDo: Implement the radio buttons
                                    ],
                                  ),
                                ),
                              ),
                              // TODO: Implement the image picker
                              Expanded(
                                flex: 4,
                                child: Container(
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: "Clear",
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: "Update image",
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  onPressed: () {},
                                  text: "Clear form",
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  onPressed: () {},
                                  text: "Upload",
                                  icon: IconlyBold.bag,
                                  backgroundColor: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}