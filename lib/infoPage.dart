import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maparkour/login.dart';

void main() {
  runApp(InfoPage());
}

class InfoPage extends StatelessWidget {
  var spot;
  InfoPage({Key key, @required this.spot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = '';
    final FirebaseAuth fireAuth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          centerTitle: true,
          title: Container(
            height: 30.0,
            child: Image.asset('img/maparkor-black.png'),
          ),
        ),
        endDrawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            Container(
              height: 80.0,
              child: DrawerHeader(
                child: Text(userName),
                decoration: BoxDecoration(
                  color: Colors.blueAccent[700],
                ),
              ),
            ),
            ListTile(
              title: Text('Cadastre um novo pico'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Sair da conta'),
              onTap: () {
                fireAuth.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainApp()));
              },
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  spot['name'],
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Image.network(spot['img'][0]),
            ],
          ),
        ));
  }
}
