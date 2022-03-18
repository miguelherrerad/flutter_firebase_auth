import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/model/user_model.dart';
import 'package:flutter_firebase_auth/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //Our form key
  final _formkey = GlobalKey<FormState>();
  //editing controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //firstName field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regExp = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("El nombre no puede estar vacío");
        }
        if (!regExp.hasMatch(value)) {
          return ("Ingresa una nombre válida (Min. 3 Caracteres)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //secondtName field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("El apellido no puede estar vacío");
        }
        return null;
      }, //validator: () {},
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Apellido",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Por favor ingresa tu correo");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Por favor ingrese un correo válido");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Correo",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regExp = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Se requiere contraseña para ingresar");
        }
        if (!regExp.hasMatch(value)) {
          return ("Ingresa una contraseña válida (Min. 6 Caracteres)");
        }
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contraseña",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //confirmPassword field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "La contraseña no coincide";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirmar Contraseña",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //signup button
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(38),
      color: Color.fromRGBO(1, 103, 169, 1),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "Registrar",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(1, 103, 169, 1)),
          onPressed: () {
            //passing this in our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      )),
                  SizedBox(height: 45),
                  firstNameField,
                  SizedBox(height: 20),
                  secondNameField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  passwordField,
                  SizedBox(height: 20),
                  confirmPasswordField,
                  SizedBox(height: 45),
                  signupButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling our firestore
    //calling our user model
    //sending these vaues

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writting all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Cuenta creada con éxito! :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
