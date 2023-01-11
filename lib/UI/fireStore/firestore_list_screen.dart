import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../Uils/Utils.dart';
import '../Auht/LoginScreen.dart';
import '../posts/add_posts.dart';
import 'AddFireStoreData.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final edit = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Fire Store')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFireStoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder:
                  (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if (snapshot.hasError) return Text('Some Error');

                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .update({'title': 'asif taj subscribe'}).then(
                                      (value) {
                                Utils().toastMessage('updated');
                              }).onError((error, stackTrace) {
                                Utils().toastMessage(error.toString());
                              });
                            },
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                          );
                        }));
              }),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    edit.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: edit,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('update')),
            ],
          );
        });
  }
}
