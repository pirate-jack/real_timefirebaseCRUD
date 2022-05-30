import 'package:flutter/material.dart';
import 'package:real_timefirebase/Details_update.dart';
import 'package:real_timefirebase/UserDetails.dart';
import 'package:real_timefirebase/UserForm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserDetails> userList = [];
  final ref = FirebaseDatabase.instance.reference().child("UserDetails");
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    set();
  }

  void set() {
    ref.once().then((DatabaseEvent databaseEvent) {
      Map<dynamic, dynamic> map = databaseEvent.snapshot.value;
      map.forEach((key, value) {
        setState(() {
          UserDetails details = new UserDetails(
              name: value["name"],
              email: value["email"],
              age: value["age"],
              key: key);
          userList.add(details);
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserForm()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Real Time Database"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: userList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return design(userList[index].name, userList[index].email,
                      userList[index].age, userList[index].key);
                }));
  }

  Widget design(String name, String email, String age, String key) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("Name : $name"),
              SizedBox(
                height: 20,
              ),
              Text("Email : $email"),
              SizedBox(
                height: 20,
              ),
              Text("Age : $age"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details_update(
                                      name: name,
                                      email: email,
                                      age: age,
                                      fKey: key,
                                    )));
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        deleteData(key);
                      },
                      icon: Icon(Icons.delete)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteData(String key) {
    ref.child(key).remove().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (route) => false);
    });
  }
}
