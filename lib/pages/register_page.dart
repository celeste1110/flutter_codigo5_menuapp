import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/pages/customer/home_customer_page.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/textfield_widget.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../ui/general/colors.dart';
import '../ui/widgets/button_normal_widget.dart';
import '../ui/widgets/textField_password_widget.dart';
import '../ui/widgets/text_widget.dart';
import 'customer/init_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirestoreService _userCollection = FirestoreService(collection: "users");
 final SPGlobal _prefs=SPGlobal();
  bool isLoading = false;

  registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;
        setState((){});
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user != null) {

          UserModel userModel= UserModel (
            fullName: _fullNameController.text,
            email: _emailController.text,
            role: "customer",
            status:true
          );

          _userCollection.addUser(userModel).then((value){
            if(value.isNotEmpty){
              _prefs.fullName=userModel.fullName;
              _prefs.email=userModel.email;
              _prefs.isLogin=true;
              _prefs.role = userModel.role;
              isLoading = false;
              setState((){});


              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitPage(),
                  ),
                      (route) => false);
            }



          });



        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(context, "El correo electrónico ya está registrado");

        } else if (e.code == 'weak-password') {
          showSnackBar(context, "La contraseña es débil, intenta con otra");
        }
        isLoading = false;
        setState((){});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/images/background.jpg",
          ),
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                flex: 4,
                child: Stack(
                    children: [
                    InkWell(
                    onTap: (){
              Navigator.pop(context);
              },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: kBrandPrimaryColor,
                  ),
                ),
                        ),
                    ],
                      ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 22.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          H1(text: "Regístrate"),
                          divider3,
                          TextNormal(
                              text: "Por favor ingresa los datos requeridos"),
                          divider30,
                          TextFieldWidget(
                              hintText: "Nombres",
                              controller: _fullNameController),
                          TextFieldWidget(
                              hintText: "Correo electrónico",
                              controller: _emailController),
                          TextFieldPasswordWidget(
                              controller: _passwordController),
                          ButtonNormalWidger(
                            text: "Registrar",
                            icon: 'happy',
                            onPressed: () {
                              registerCustomer();
                            },
                          ),
                        ],
                          ),
                    ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? Container(
            color: Colors.white.withOpacity(0.8),
            child: LoadingWidget(),
          ): const SizedBox(),
        ],
      ),
    );
  }
}
