import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
          child: Form(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset('img/maparkor-black.png'),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "e-mail"),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.lock),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "senha"),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  RaisedButton(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {},
                    child: Text("Login"),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text("Criar conta"),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
