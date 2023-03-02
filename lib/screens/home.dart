import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/form.dart';
import 'package:firebase/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/googleSignIn.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  State<HomeListScreen> createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(user.photoURL.toString()))),
            )),
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
              onPressed: () async {
                await GoogleAuth().logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form(context, true);
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
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        form(
                            context,
                            false,
                            snapshot.data!.docs[index].reference.id,
                            snapshot.data!.docs[index]['FirstName'],
                            snapshot.data!.docs[index]['SecondName']);
                      },
                      icon: const Icon(Icons.edit)),
                  trailing: IconButton(
                      onPressed: () {
                        FirestoreOperations().deleteData(snapshot, index);
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
}
