import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maparkour/mainPage.dart';

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
  TextEditingController usernameController = new TextEditingController();
  bool isNewUser = false;
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void changeNewUserStatus() {
    setState(() {
      isNewUser = !isNewUser;
      print(isNewUser);
    });
  }

  void submitForm() async {
    if (isNewUser) {
      //cadastra o usuário
      var userEmail = emailController.text;
      var userPassword = passwordController.text;
      var userName = usernameController.text;

      try {
        QuerySnapshot allUsers =
            await Firestore.instance.collection('users').getDocuments();
        bool isUsernameInUse = false;

        for (DocumentSnapshot eachUser in allUsers.documents) {
          if (eachUser['username'] == userName) {
            isUsernameInUse = true;
          }
        }

        if (!isUsernameInUse) {
          try {
            await fireAuth
                .createUserWithEmailAndPassword(
                    email: userEmail, password: userPassword)
                .then((user) async {
              var loggedUser = await fireAuth.currentUser();
              Firestore.instance
                  .collection('users')
                  .document(loggedUser.uid)
                  .setData({"username": userName});
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          } catch (e) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(e.toString()),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red.withOpacity(0.8),
            ));
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Nome de usuário já em uso."),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red.withOpacity(0.8),
          ));
        }
      } catch (e) {
        //Lidar com erros (mostrar naquele cookie?)
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red.withOpacity(0.8),
        ));
        print("error:");
        print(e);
      }
    } else {
      //loga o usuário
      var userEmail = emailController.text;
      var userPassword = passwordController.text;

      try {
        await fireAuth.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        // print(fireAuth.currentUser());
      } catch (e) {
        //Lidar com erros (mostrar naquele snackbar)
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red.withOpacity(0.8),
        ));

        print("error:");
        print(e);
      }

      // print(userPassword);
    }
  }

  void testAuth() async {
    var user = await fireAuth.currentUser();
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (context) => SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Visibility(
                      visible: isNewUser,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_box),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: usernameController,
                              maxLength: 13,
                              decoration:
                                  InputDecoration(labelText: "Nome de usuário"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                            controller: passwordController,
                            obscureText: true,
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
                      onPressed: submitForm,
                      child: Text(isNewUser ? "Cadastre-se" : "Login"),
                    ),
                    FlatButton(
                      onPressed: changeNewUserStatus,
                      child: Text(isNewUser ? "Faça login" : "Criar conta"),
                    ),
                    FlatButton(
                      onPressed: () {
                        final snackBar = SnackBar(
                          content: Text('Yay! A SnackBar!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Text("teste"),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
