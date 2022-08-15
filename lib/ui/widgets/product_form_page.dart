import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/button_normal_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/textfield_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/category_model.dart';
import '../../services/firestore_service.dart';
import '../general/colors.dart';
import 'general_widget.dart';
import 'my_appbar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductFormPage extends StatefulWidget {
  List<CategoryModel> categories;
  ProductsModel? productsModel;

  ProductFormPage({required this.categories, this.productsModel});
  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  TextEditingController _ingredientController = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  TextEditingController _discountController = TextEditingController();

  TextEditingController _timeController = TextEditingController();

  TextEditingController _servingController = TextEditingController();

  TextEditingController _rateController = TextEditingController();
  List<String> _ingredients = [];
  List<CategoryModel> _categories = [];
  String categoryValue = "";
  XFile? _image;
  bool isLoading = true;


  final FirestoreService _categoryService =
      FirestoreService(collection: "categories");

  final FirestoreService _productService =
      FirestoreService(collection: "products");
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    // _categories = await _categoryService.getCategories();
    // categoryValue = _categories.first.id!;
    // _categories = await _categoryService.getCategories();
    categoryValue = widget.categories.first.id!;
    if (widget.productsModel != null) {
      _nameController.text = widget.productsModel!.name;
      _descriptionController.text = widget.productsModel!.description;
      _priceController.text = widget.productsModel!.price.toStringAsFixed(2);
      _discountController.text = widget.productsModel!.discount.toString();
      _timeController.text = widget.productsModel!.time.toString();
      _servingController.text = widget.productsModel!.serving.toString();
      _rateController.text = widget.productsModel!.rate.toStringAsFixed(1);
      _ingredients = widget.productsModel!.ingredients;
      categoryValue = widget.productsModel!.categoryId;
    }
    isLoading = false;
    setState(() {});
  }

  getImageGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    _image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  getImageCamera() async {
    ImagePicker _imagePicker = ImagePicker();
    _image = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<String> uploadImageStorage() async {
    firebase_storage.Reference _reference = _storage.ref().child('products');
    String time = DateTime.now().toString();
    firebase_storage.TaskSnapshot uploadTask =
        await _reference.child('$time.jpg').putFile(File(_image!.path));
    String url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  saveProducts() async {
    if (_formKey.currentState!.validate()) {
      ProductsModel productsModel = ProductsModel(
        image: '',
        categoryId: categoryValue,
        rate: double.parse(_rateController.text),
        price: double.parse(_priceController.text),
        name: _nameController.text,
        discount: int.parse(_discountController.text),
        ingredients: _ingredients,
        description: _descriptionController.text,
        time: int.parse(_timeController.text),
        serving: int.parse(_servingController.text),
      );

      if(_image!=null) {
        String imageUrl=await uploadImageStorage();
        productsModel.image=imageUrl;
      }else{
        if(widget.productsModel!=null){
          productsModel.image=widget.productsModel!.image;
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Row(
                children: [
                  Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Por vfavor seleccione una imagen'),
                ],
              ),
            ),
          );
          return;
        }


      }


      if(widget.productsModel==null){
        _productService.addProduct(productsModel).then((value) {
          isLoading = false;
          setState(() {});
          Navigator.pop(context);
        });
      }else{
        productsModel.id=widget.productsModel!.id;
        _productService.updateProduct(productsModel).then((value) {
          isLoading = false;
          setState(() {});
          Navigator.pop(context);
        });


      }

      // if (_image != null ) {
      //   isLoading = true;
      //   setState(() {});
      //   String imageUrl = await uploadImageStorage();
      //
      //   _productService.addProduct(productsModel).then((value) {
      //     isLoading = false;
      //     setState(() {});
      //     Navigator.pop(context);
      //   });
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.redAccent,
      //       behavior: SnackBarBehavior.floating,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //       content: Row(
      //         children: [
      //           Icon(
      //             Icons.image_not_supported,
      //             color: Colors.white,
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Text('Por vfavor seleccione una imagen'),
      //         ],
      //       ),
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(
          text: "${widget.productsModel==null ? 'Agregar ':'Actualizar '} producto",
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      hintText: "Nombre del producto",
                      controller: _nameController,
                    ),
                    TextFieldWidget(
                      hintText: "Descripción",
                      maxLines: 4,
                      controller: _descriptionController,
                    ),
                    Row(
                      children: [
                        TextNormal(text: " Categoría:"),
                      ],
                    ),
                    divider6,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12.0,
                            offset: const Offset(4, 4),
                          )
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: categoryValue,
                          isExpanded: true,
                          items: widget.categories
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: TextNormal(
                                    text: e.category,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            categoryValue = value!;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    divider20,
                    divider6,
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Precio",
                            isNumeric: true,
                            controller: _priceController,
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Descuento",
                            isNumeric: true,
                            controller: _discountController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Tiempo",
                            isNumeric: true,
                            controller: _timeController,
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Porciones",
                            isNumeric: true,
                            controller: _servingController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Calificación",
                            isNumeric: true,
                            controller: _rateController,
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                      child: Divider(
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ),
                    TextNormal(
                      text: "Ingredientes",
                    ),
                    divider12,
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Ingrediente",
                            controller: _ingredientController,
                            validate: false,
                          ),
                        ),
                        dividerWidth10,
                        InkWell(
                          onTap: () {
                            _ingredients.add(_ingredientController.text);
                            print(_ingredients.length);
                            _ingredientController.clear();
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: kBrandSecondaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _ingredients.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12.0,
                                  offset: const Offset(4, 4),
                                )
                              ],
                            ),
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _ingredients.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: TextNormal(text: _ingredients[index]),
                                  trailing: IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icons/trash.svg',
                                      height: 18.0,
                                      color:
                                          kBrandPrimaryColor.withOpacity(0.8),
                                    ),
                                    onPressed: () {
                                      _ingredients.removeAt(index);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/box.png',
                                  height: 90.0,
                                  color: kBrandPrimaryColor.withOpacity(0.8),
                                ),
                                divider6,
                                TextNormal(
                                  text: "Aún no hay ingredientes",
                                ),
                              ],
                            )),
                    divider20,
                    const SizedBox(
                      height: 30,
                      child: Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    TextNormal(text: 'Imagen del producto'),
                    divider20,
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageGallery();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xfff72585),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              icon: SvgPicture.asset(
                                'assets/icons/gallery.svg',
                                color: Colors.white,
                              ),
                              label: Text(
                                'Galeria',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageCamera();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                              icon: SvgPicture.asset(
                                'assets/icons/camera.svg',
                                color: Colors.white,
                              ),
                              label: Text(
                                'Camara',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    divider20,
                    Container(
                      height: heigth * 0.32,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12.0,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image(
                          image: _image != null
                              ? FileImage(File(_image!.path))
                              : widget.productsModel != null
                                  ? NetworkImage(widget.productsModel!.image)
                                  : AssetImage('assets/images/placeholder.png')
                                      as ImageProvider,
                          fit: BoxFit.cover,
                          //image: FileImage(File(_image!.path)),
                        ),
                      ),
                    ),
                    divider30,
                ButtonNormalWidger(
                  text: "Guardar",
                  icon: 'save',
                  onPressed: () {
                    saveProducts();
                  },
                ),
                    divider40,
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kBrandSecondaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
