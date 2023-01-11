import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_first/Uils/Utils.dart';
import 'package:firebase_first/widgets/roundbutton.dart';
import 'package:flutter/material.dart';

class AddPostScreeScreen extends StatefulWidget {
  const AddPostScreeScreen({super.key});

  @override
  State<AddPostScreeScreen> createState() => _AddPostScreeScreenState();
}

class _AddPostScreeScreenState extends State<AddPostScreeScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What is in you mind',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Round_Button(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    Utils().toastMessage('Post Added');
                    setState(() {
                      loading = false;
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
