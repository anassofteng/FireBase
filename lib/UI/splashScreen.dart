import 'package:firebase_first/firebaseServices/splash_services.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(''),),
      body: Center(
        child: Text(
          'FireBase Tutorial',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
