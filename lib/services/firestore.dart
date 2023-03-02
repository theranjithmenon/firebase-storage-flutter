import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreOperations {
  final user = FirebaseAuth.instance.currentUser!;

  void addData(firstName, secondName) {
    FirebaseFirestore.instance
        .collection(user.email.toString())
        .add({"FirstName": firstName, "SecondName": secondName});
  }

  void editData(id, firstName, secondName) {
    FirebaseFirestore.instance
        .collection(user.email.toString())
        .doc(id)
        .update({"FirstName": firstName, "SecondName": secondName});
  }

  void deleteData(snapshot, index) {
    FirebaseFirestore.instance
        .collection(user.email.toString())
        .doc(snapshot.data!.docs[index].reference.id)
        .delete();
  }
}
