import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_first/UI/posts/posts_Screen.dart';
import 'package:flutter/material.dart';

import '../../Uils/Utils.dart';
import '../../widgets/roundbutton.dart';

class VerifyWithCode extends StatefulWidget {
  final String verificationId;
  const VerifyWithCode({super.key, required this.verificationId});

  @override
  State<VerifyWithCode> createState() => _VerifyWithCodeState();
}

class _VerifyWithCodeState extends State<VerifyWithCode> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('verify')),
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
              decoration: InputDecoration(hintText: 'enter 6 digit code'),
            ),
            SizedBox(
              height: 30,
            ),
            Round_Button(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final Credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: phoneNumberController.text.toString());
                  try {
                    await auth.signInWithCredential(Credential);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
