import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_clone/UI/loginScreen.dart';
import 'package:uber_clone/UI/mainScreen.dart';
// import 'package:uber_clone/UI/mainScreen.dart';
import 'package:uber_clone/main.dart';
import 'package:uber_clone/widgets/progressDialog.dart';

// ignore: must_be_immutable
class Register extends StatelessWidget {
  static const String idScreen = "registerScreen";
  // const Register({Key? key}) : super(key: key);
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      onPrimary: Colors.black,
      primary: Colors.yellow,
      shadowColor: Colors.amber,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 45,
              ),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 350,
                height: 200,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                "Driver Register",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Brand Bold", fontSize: 24),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Enter name",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Enter phone number",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Enter email",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Enter password",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameTextEditingController.text.length < 4) {
                          dispayToastMessage(
                              "Name must be greater than 3 characters",
                              context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          dispayToastMessage(
                              "Email address is not valid", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          dispayToastMessage(
                              "Phone number is required", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          dispayToastMessage(
                              "Password must be atleast 8 characters", context);
                        }

                        registerNewUser(context);
                      },
                      style: style,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Brand Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black, // foreground
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text('Already have an account? Login here'),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Please wait...",
        );
      },
    );
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      dispayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    // ignore: unnecessary_null_comparison
    if (User != null) {
      //save user to the db
      userRef.child(firebaseUser!.uid);
      // ignore: unused_local_variable
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      dispayToastMessage("Account created successfully", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      //error creating the user
      Navigator.pop(context);
      dispayToastMessage("User has not been created", context);
    }
  }
}

dispayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
