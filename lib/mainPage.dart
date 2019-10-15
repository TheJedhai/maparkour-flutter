import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListSpots(),
    );
  }
}

class ListSpots extends StatefulWidget {
  @override
  _ListSpotsState createState() => _ListSpotsState();
}

class _ListSpotsState extends State<ListSpots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("Login works!!!!!")],
          ),
        )),
      ),
    );
  }
}
