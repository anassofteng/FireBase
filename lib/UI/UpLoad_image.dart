import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_first/Uils/Utils.dart';
import 'package:firebase_first/widgets/roundbutton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'Auht/LoginScreen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  DatabaseReference databaseref = FirebaseDatabase.instance.ref('post');
  Future getImageGallery() async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                )),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Center(child: Icon(Icons.photo_album)),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Round_Button(
                title: 'UpLoad',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref('/folder/' +
                          DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    databaseref
                        .child('1')
                        .set({'id': '1212', 'title': newUrl.toString()}).then(
                            (value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('uploaded');
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }),
          ],
        ),
      ),
    );
  }
}
