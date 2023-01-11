import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_first/UI/Auht/LoginScreen.dart';
import 'package:firebase_first/Uils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final search = TextEditingController();
  final edit = TextEditingController();
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
        title: Center(child: Text('Post Screen')),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreeScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, Index) {
                  final title = snapshot.child('title').value.toString();
                  if (search.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title,
                                      snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove();
                                },
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )),
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(search.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container(
                      child: Text(''),
                    );
                  }
                }),
          ),
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
                    ref.child(id).update(
                        {'title': edit.text.toLowerCase()}).then((value) {
                      Utils().toastMessage('message');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('update')),
            ],
          );
        });
  }
}

// Expanded(
//             child: StreamBuilder(
//               stream: ref.onValue,
//               builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 } else {
//                   Map<dynamic, dynamic> map =
//                       snapshot.data!.snapshot.value as dynamic;
//                   List<dynamic> list = [];
//                   list.clear();
//                   list = map.values.toList();

//                   return ListView.builder(
//                       itemCount: snapshot.data!.snapshot.children.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(list[index]['title'].toString()),
//                           subtitle: Text(list[index]['id'].toString()),
//                         );
//                       });
//                 }
//               },
//             ),
//           ),