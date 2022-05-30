import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';

class Details_update extends StatefulWidget {
  final String name, email, age, fKey;

  const Details_update({Key key, this.name, this.email, this.age, this.fKey})
      : super(key: key);

  @override
  State<Details_update> createState() => _Details_updateState();
}

class _Details_updateState extends State<Details_update> {
  TextEditingController Name = new TextEditingController();
  TextEditingController Email = new TextEditingController();
  TextEditingController Age = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Name.text=widget.name;
    Email.text=widget.email;
    Age.text=widget.age;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Details"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: Name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: " Name",
                labelText: " Name",
              ),
              textInputAction: TextInputAction.next,
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: Email,
              decoration: InputDecoration(
                hintText: "Email",
                labelText: "Email",
              ),
              textInputAction: TextInputAction.next,
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: Age,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Age",
                labelText: "Age",
              ),
              textInputAction: TextInputAction.done,
            ),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(
              onPressed: () {
                update(widget.fKey);
              },
              child: Text("Update Details"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> update(String key) {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "name": Name.text,
      "email": Email.text,
      "age": Age.text,
    };
    ref.child('UserDetails').child(key).set(data).then((v) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success")));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);
    });
  }
}
