import 'dart:math';
import 'package:firebase_first/Uils/Utils.dart';
import 'package:firebase_first/widgets/roundbutton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'VerifyCode.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: '+1 234 3455 234'),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(35),
              child: Round_Button(
                  title: 'login',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });

                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          Utils().toastMessage(e.toString());
                        },
                        codeSent: (String verificationID, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyWithCode(
                                        verificationId: verificationID,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
