import 'package:firebase/services/firestore.dart';
import 'package:flutter/material.dart';

form(context, isNew, [id, fName, sName]) {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController secondName = TextEditingController();
  if (!isNew) {
    firstName.text = fName;
    secondName.text = sName;
  }
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: firstName,
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
                controller: secondName,
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
                  if (secondName.text == "" || firstName.text == "") return;
                  (isNew)
                      ? FirestoreOperations()
                          .addData(firstName.text, secondName.text)
                      : FirestoreOperations()
                          .editData(id, firstName.text, secondName.text);
                  Navigator.pop(context);
                },
                child: Text((isNew) ? 'Add' : 'Update'),
              )
            ],
          ),
        );
      });
}
