import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../UI/Auht/LoginScreen.dart';
import '../UI/UpLoad_image.dart';
import '../UI/fireStore/firestore_list_screen.dart';
import '../UI/posts/posts_Screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UploadImageScreen()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
