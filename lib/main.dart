import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:uber_clone/UI/Homepage.dart';
import 'package:uber_clone/UI/loginScreen.dart';
import 'package:uber_clone/UI/mainScreen.dart';
import 'package:uber_clone/UI/registerScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: "Brand-Regular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: LoginScreen(),
      initialRoute: LoginScreen.idScreen,
      routes: {
        Register.idScreen: (context) => Register(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
      },
    );
  }
}
