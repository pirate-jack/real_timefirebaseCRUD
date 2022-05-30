import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:real_timefirebase/main.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController age = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Form"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: age,
              decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Age",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _sendToServer();
                },
                child: Text("Insert"))
          ],
        ),
      ),
    );
  }

  Future<void> _sendToServer() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "name": name.text,
      "email": email.text,
      "age": age.text,
    };
    ref.child('UserDetails').push().set(data).then((v) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success")));

      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

}
