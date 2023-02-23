import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(
                                        snapshot.data!.docs[index].reference.id)
                                    .delete();
                              },
                              icon: const Icon(Icons.delete)),
                          title: Text(snapshot.data!.docs[index]['Name']),
                          subtitle: Text(snapshot.data!.docs[index]['Email']),
                        );
                      });
                },
              )),
              Column(
                children: [
                  TextField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: "Email",
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
                      FirebaseFirestore.instance.collection('user').doc().set(
                          {"Name": _name.text, "Email": _email.text});
                      setState(() {
                        _email.text = "";
                        _name.text = "";
                      });
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
