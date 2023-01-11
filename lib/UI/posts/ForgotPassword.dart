import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_first/Uils/Utils.dart';
import 'package:flutter/material.dart';

import '../../widgets/roundbutton.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailcontroller = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Reset Password')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 40,
            ),
            Round_Button(
              title: 'Forgot',
              onTap: () {
                auth
                    .sendPasswordResetEmail(
                        email: emailcontroller.text.toString())
                    .then((value) {
                  Utils().toastMessage('check your email to reset password');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
