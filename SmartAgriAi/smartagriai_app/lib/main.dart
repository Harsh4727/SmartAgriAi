import 'package:flutter/material.dart';
//import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(SmartAgriAI());
}

class SmartAgriAI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SmartAgriAI",
      home: SplashScreen(),
    );
  }
}