import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/pages/register_page.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/button_normal_widget.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helpers/sp_global.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../ui/general/colors.dart';
import '../ui/widgets/general_widget.dart';
import '../ui/widgets/textField_password_widget.dart';
import '../ui/widgets/text_widget.dart';
import '../ui/widgets/textfield_widget.dart';
import 'admin/home_admin_page.dart';
import 'customer/home_customer_page.dart';
import 'customer/init_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FirestoreService _userReference = FirestoreService(collection: "users");
  final SPGlobal _prefs = SPGlobal();
 final GoogleSignIn _googleSignIn=GoogleSignIn(scopes: ['email']);


  void _login() async {
    try{
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        _userReference.getUser(_emailController.text).then((value) {
          if (value != null) {
            if (value.role == "customer" && value.status) {
              _prefs.fullName = value.fullName;
              _prefs.email = value.email;
              _prefs.isLogin = true;
              _prefs.role = value.role;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitPage(),
                  ),
                      (route) => false);
            } else if (value.role == "admin" && value.status) {
              _prefs.fullName = value.fullName;
              _prefs.email = value.email;
              _prefs.isLogin = true;
              _prefs.role = value.role;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeAdminPage(),
                  ),
                      (route) => false);
            }
        }
        });
      }
    } on FirebaseAuthException catch (e) {

      if (e.code == 'invalid-email') {
        showSnackBar(context, "El correo electrónico es incorrecto");
      } else if (e.code == 'user-not-found') {

        showSnackBar(context, "El usuario no existe");

      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "La contraseña es incorrecta");

      }
    }

  }
  void _loginWithDoogle() async{
   GoogleSignInAccount? _googleSignInAccount= await _googleSignIn.signIn();
   if(_googleSignInAccount == null){
     return;
   }



   GoogleSignInAuthentication _googleSignInAuth = await _googleSignInAccount.authentication;

   OAuthCredential credential = GoogleAuthProvider.credential(
     accessToken: _googleSignInAuth.accessToken,
     idToken: _googleSignInAuth.idToken,
   );

   UserCredential userCredential =
   await FirebaseAuth.instance.signInWithCredential(credential);

   if (userCredential.user != null) {
     _userReference.getUser(userCredential.user!.email!).then((UserModel? value) {
       if (value == null) {
         UserModel userModel = UserModel(
           fullName: userCredential.user!.displayName!,
           email: userCredential.user!.email!,
           role: "customer",
           status: true,
         );
         _userReference.addUser(userModel).then((value){
           if(value.isNotEmpty){
             _prefs.fullName = userModel.fullName;
             _prefs.email = userModel.email;
             _prefs.isLogin = true;
             _prefs.role = userModel.role;
             Navigator.pushAndRemoveUntil(
                 context,
                 MaterialPageRoute(
                   builder: (context) => InitPage(),
                 ),
                     (route) => false);
           }

     });
       } else{

         _prefs.fullName = value.fullName;
         _prefs.email = value.email;
         _prefs.isLogin = true;
         _prefs.role = value.role;

         Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(
               builder: (context) => InitPage(),
             ),
                 (route) => false);
   }


     });

  }
  }

  void _loginWithFacebook() async{
    LoginResult _loginResult=await FacebookAuth.instance.login();
    if(_loginResult.status==LoginStatus.success){
      Map<String,dynamic> userData =await FacebookAuth.instance.getUserData();
      AccessToken accessToken=_loginResult.accessToken!;
      OAuthCredential credential=FacebookAuthProvider.credential(accessToken.token);
      UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        _userReference.getUser(userCredential.user!.email!).then((UserModel? value) {
          if (value == null) {
            UserModel userModel = UserModel(
              fullName: userCredential.user!.displayName!,
              email: userCredential.user!.email!,
              role: "customer",
              status: true,
            );
            _userReference.addUser(userModel).then((value){
              if(value.isNotEmpty){
                _prefs.fullName = userModel.fullName;
                _prefs.email = userModel.email;
                _prefs.isLogin = true;
                _prefs.role = userModel.role;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitPage(),
                    ),
                        (route) => false);
              }

            });
          } else{

            _prefs.fullName = value.fullName;
            _prefs.email = value.email;
            _prefs.isLogin = true;
            _prefs.role = value.role;

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => InitPage(),
                ),
                    (route) => false);
          }


  });
            }
        }
        }


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/background.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(),
              ),
              Expanded(
                flex: 12,
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
                          H1(text: "Iniciar Sesión"),
                          divider3,
                          TextNormal(
                              text: "Por favor ingresa los datos requeridos"),
                          divider30,
                          TextFieldWidget(
                              hintText: "Correo electrónico",
                              controller: _emailController),
                          TextFieldPasswordWidget(
                              controller: _passwordController),
                          ButtonNormalWidger(
                            text: "Iniciar Sesión",
                            icon: 'login',
                            onPressed: () {
                              _login();
                            },
                          ),
                          divider12,
                          TextNormal(text: "O también utiliza tus redes sociales"),
                          divider12,
                          ButtonNormalWidger(
                            text: "Iniciar sesión con Google",
                            icon: 'google',
                            color: Color(0xfff84b2a),
                            onPressed: () {
                              _loginWithDoogle();

                            },
                          ),
                          divider12,
                          ButtonNormalWidger(
                            text: "Iniciar sesión con Facebook",
                            icon: 'facebook',
                            color: Color(0xff507CC0),
                            onPressed: () {

                              // _googleSignIn.signOut();
                              _loginWithFacebook();

                            },
                          ),
                          divider12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextNormal(
                                text: "¿Aún no tienes una cuenta? ",
                              ),
                              dividerWidth6,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Regístrate",
                                  style: TextStyle(
                                    color: kBrandPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
