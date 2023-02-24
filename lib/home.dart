import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTo();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data!.docs.length == 0) {
            return Center(child: Text("empty"));
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        _editData(
                            snapshot.data!.docs[index]['Name'],
                            snapshot.data!.docs[index]['Email'],
                            snapshot.data!.docs[index].reference.id);
                      },
                      icon: Icon(Icons.edit)),
                  trailing: IconButton(
                      onPressed: () {
                        _deleteData(snapshot, index);
                      },
                      icon: const Icon(Icons.delete)),
                  title: Text(snapshot.data!.docs[index]['Name']),
                  subtitle: Text(snapshot.data!.docs[index]['Email']),
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
                      if (_email.text == "" || _name.text == "") return;
                      FirebaseFirestore.instance
                          .collection('user')
                          .add({"Name": _name.text, "Email": _email.text});
                      setState(() {
                        _email.text = "";
                        _name.text = "";
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
        .collection('user')
        .doc(snapshot.data!.docs[index].reference.id)
        .delete();
  }

  void _editData(name, email, id) {
    _name.text = name;
    _email.text = email;
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
                    controller: _name,
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
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
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
                      if (_email.text == "" || _name.text == "") return;
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(id)
                          .update({"Name": _name.text, "Email": _email.text});
                      setState(() {
                        _email.text = "";
                        _name.text = "";
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
