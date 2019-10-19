import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maparkour/login.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListSpots(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListSpots extends StatefulWidget {
  @override
  _ListSpotsState createState() => _ListSpotsState();
}

class _ListSpotsState extends State<ListSpots> {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String userName = "";
  var spotsDatabase = [];

  @override
  void initState() {
    super.initState();
    initUser();
    // fireAuth.signOut();
  }

  initUser() async {
    user = await fireAuth.currentUser();
    setState(() {
      getUserName();
      initDatabase();
    });
  }

  // Future<String> getUsername() async {
  //   FirebaseUser user = await fireAuth.currentUser();

  //   return "omg";
  // }

  void testAuth() async {
    // fireAuth.signOut();
    setState(() {});
  }

  void initDatabase() async {
    QuerySnapshot allSpots = await Firestore.instance
        .collection('spots')
        .document('DF')
        .collection('Brasília')
        .getDocuments();

    // spotsDatabase = allSpots.documents;

    for (DocumentSnapshot eachSpot in allSpots.documents) {
      spotsDatabase.add(eachSpot);
      print(eachSpot.data);
    }

    // print(spotsDatabase);
  }

  void getUserName() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();

    userName = snapshot.data['username'];
    // print(snapshot.data['']);
    setState(() {});
  }

  Widget smallCard(String mainImage, String title, String excerpt) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 160.0,
                  height: 160.0,
                  child: Image.network(
                    mainImage,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              excerpt,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        onTap: () {
          // _showContactPage(contact: contacts[index]);
          print('Gesture Detection funfa');
        });
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainApp()));
            },
          ),
        ]),
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView.builder(
          itemCount: spotsDatabase.length,
          itemBuilder: (context, index) {
            return smallCard(spotsDatabase[index]['img'][0],
                spotsDatabase[index]['name'], spotsDatabase[index]['excerpt']);
          },
        ),
      )),
    );
  }
}

// ListView(
//           padding: EdgeInsets.zero, children: <Widget>[
//           Container(
//             height: 80.0,
//             child: DrawerHeader(
//               child: Center(
//                 child: Text(
//                   'Brasília',
//                   style: TextStyle(fontSize: 30.0, color: Colors.white),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//               ),
//             ),
//           ),
//         ])
