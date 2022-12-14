import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
// ignore: deprecated_member_use
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app_web_admin_panel/responsive.dart';
import 'package:grocery_app_web_admin_panel/screens/loading_manager.dart';
import 'package:grocery_app_web_admin_panel/services/utils.dart';
import 'package:grocery_app_web_admin_panel/widgets/buttons.dart';
import 'package:grocery_app_web_admin_panel/widgets/side_menu.dart';
import 'package:grocery_app_web_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/menu_controller.dart';
import '../services/global_method.dart';
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
  String _catValue = "Vegetables";
  int _groupValue = 1;
  bool _isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  bool _isLoading = false;
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

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subTitle: "Please, pick up an image", context: context);
        return;
      }

      final uuid = const Uuid().v4();
      try {
        setState(() => _isLoading = true);
        fb.StorageReference storageRef =
            fb.storage().ref().child('productsImages').child('${uuid}jpg');
        final fb.UploadTaskSnapshot uploadTaskSnapshot =
            await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
        Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('products').doc(uuid).set({
          'id': uuid,
          'title': _titleController.text,
          'price': _priceController.text,
          'salePrice': 0.1,
          'imageUrl': imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isPiece': _isPiece,
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: 'Product uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        setState(() => _isLoading = false);
        GlobalMethods.errorDialog(
            subTitle: "${error.message}", context: context);
        print(error.message);
      } catch (error) {
        setState(() => _isLoading = false);
        GlobalMethods.errorDialog(subTitle: "$error", context: context);
        print(error);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _isPiece = false;
    _groupValue = 1;
    _catValue = "Vegetables";
    setState(
      () {
        _pickedImage = null;
        webImage = Uint8List(8);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: scaffoldColor,
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
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
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
                          context
                              .read<MenuController>()
                              .controlAddProductsMenu();
                        },
                        title: 'Add Product',
                        showTextField: false,
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
                                return value!.isEmpty
                                    ? "Please, enter a title"
                                    : null;
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              return value!.isEmpty
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
                                        _categoryDropDown(),
                                        const SizedBox(height: 20.0),
                                        TextWidget(
                                          text: "Measuring unit",
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: "KG",
                                              color: color,
                                            ),
                                            Radio(
                                              value: 1,
                                              groupValue: _groupValue,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    _groupValue = 1;
                                                    _isPiece = false;
                                                  },
                                                );
                                              },
                                              activeColor: Colors.green,
                                            ),
                                            TextWidget(
                                              text: "Piece",
                                              color: color,
                                            ),
                                            Radio(
                                              value: 2,
                                              groupValue: _groupValue,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    _groupValue = 2;
                                                    _isPiece = true;
                                                  },
                                                );
                                              },
                                              activeColor: Colors.green,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: size.width > 650
                                          ? 350
                                          : size.width * 0.5,
                                      decoration: BoxDecoration(
                                        color: scaffoldColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: _pickedImage == null
                                          ? dottedBorder(
                                              color: color,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: kIsWeb
                                                  ? Image.memory(
                                                      webImage,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.file(
                                                      _pickedImage!,
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                _pickedImage = null;
                                                webImage = Uint8List(8);
                                              },
                                            );
                                          },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: _clearForm,
                                    text: "Clear form",
                                    icon: IconlyBold.danger,
                                    backgroundColor: Colors.red.shade300,
                                  ),
                                  ButtonsWidget(
                                    onPressed: _uploadForm,
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
      ),
    );
  }

  Future<void> _pickImage() async {
    //! OPEN FROM A MOBILE PHONE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(
          () {
            _pickedImage = selected;
          },
        );
      } else {
        print("No image has been picked");
      }
    }
    //! WEB CASE
    else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(
          () {
            webImage = f;
            _pickedImage = File("a");
          },
        );
      } else {
        print("No image has been picked");
      }
    }
    //! EITHER MOBILE NOR WEB
    else {
      print("Something went wrong");
    }
  }

  Widget dottedBorder({required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: const [6.7],
        borderType: BorderType.RRect,
        color: color,
        radius: const Radius.circular(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                color: color,
                size: 50,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: TextWidget(
                  text: "Choose an image",
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: color,
            ),
            value: _catValue,
            onChanged: (value) {
              setState(
                () {
                  _catValue = value!;
                },
              );

              print(_catValue);
            },
            hint: const Text("Select a category"),
            items: const [
              DropdownMenuItem(
                value: "Vegetables",
                child: Text("Vegetables"),
              ),
              DropdownMenuItem(
                value: "Fruits",
                child: Text("Fruits"),
              ),
              DropdownMenuItem(
                value: "Grains",
                child: Text("Grains"),
              ),
              DropdownMenuItem(
                value: "Nuts",
                child: Text("Nuts"),
              ),
              DropdownMenuItem(
                value: "Herbs",
                child: Text("Herbs"),
              ),
              DropdownMenuItem(
                value: "Spices",
                child: Text("Spices"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
