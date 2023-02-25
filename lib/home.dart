import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'googleSignIn.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _secondName = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoURL.toString()),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.displayName.toString(),
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              user.email.toString(),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async{
                await GoogleAuth().logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTo();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(user.email.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("empty"));
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        _editData(
                            snapshot.data!.docs[index]['FirstName'],
                            snapshot.data!.docs[index]['SecondName'],
                            snapshot.data!.docs[index].reference.id);
                      },
                      icon: const Icon(Icons.edit)),
                  trailing: IconButton(
                      onPressed: () {
                        _deleteData(snapshot, index);
                      },
                      icon: const Icon(Icons.delete)),
                  title: Text(snapshot.data!.docs[index]['FirstName']),
                  subtitle: Text(snapshot.data!.docs[index]['SecondName']),
                );
              });
        },
      ),
    );
  }

  _addTo() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _firstName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "First Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _secondName,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Second Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.blueAccent.shade100,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_secondName.text == "" || _firstName.text == "")
                        return;
                      FirebaseFirestore.instance
                          .collection(user.email.toString())
                          .add({
                        "FirstName": _firstName.text,
                        "SecondName": _secondName.text
                      });
                      setState(() {
                        _secondName.text = "";
                        _firstName.text = "";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _deleteData(snapshot, index) {
    FirebaseFirestore.instance
        .collection(user.email.toString())
        .doc(snapshot.data!.docs[index].reference.id)
        .delete();
  }

  void _editData(firstName, secondName, id) {
    _firstName.text = firstName;
    _secondName.text = secondName;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _firstName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _secondName,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.blueAccent.shade100,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_secondName.text == "" || _firstName.text == "")
                        return;
                      FirebaseFirestore.instance
                          .collection(user.email.toString())
                          .doc(id)
                          .update({
                        "FirstName": _firstName.text,
                        "SecondName": _secondName.text
                      });
                      setState(() {
                        _secondName.text = "";
                        _firstName.text = "";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Update"),
                  )
                ],
              ),
            ),
          );
        });
  }
}
