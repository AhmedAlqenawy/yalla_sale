import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yalla_sale/splash_screen.dart';
import 'MyHomePage.dart';
import 'MyHomePage.dart';
import 'Registration.dart';
import 'TryMyHomePage.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

AuthResult fireauth;

class _LoginPageState extends State<LoginPage> {
  var check = true;
  void onchange(val) {
    print(val);
    setState(() {
      check = val;
    });
  }

  void done() async {
    final formdata = _formKey.currentState;

    try {
      fireauth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: umail, password: upass);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => splash_screen()));

    } catch (error) {
      print(umail + upass + fireauth.user.email);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _pass;
  String upass, umail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 755,
          child: Column(
            children: <Widget>[
              Padding(
                child: Image.asset(
                  "images/project_logo.png",
                  width: 150,
                  height: 100,
                ),
                padding: EdgeInsets.only(top: 50),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Card(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                child: SizedBox(
                                  height: 70,
                                  width: 300,
                                  child: TextFormField(
                                    maxLines: 1,
                                    maxLength: 20,
                                    cursorColor: Colors.black,
                                    autofocus: false,
                                    style: TextStyle(
                                      decorationColor: Colors.limeAccent,
                                      wordSpacing: .5,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      labelText: "Enter Email",
                                    ),
                                    // ignore: missing_return
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'Please Enter Your Email';
                                      }
                                    },
                                    onChanged: (val) {
                                      umail = val;
                                    },
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                child: SizedBox(
                                  height: 70,
                                  width: 300,
                                  child: TextFormField(
                                    maxLines: 1,
                                    maxLength: 20,
                                    cursorColor: Colors.black,
                                    autofocus: false,
                                    style: TextStyle(
                                      decorationColor: Colors.limeAccent,
                                      wordSpacing: .5,
                                      fontSize: 15, // height: 20,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.next,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      //hintText: "Enter Password" ,
                                      prefixIcon: Icon(Icons.lock_outline),
                                      prefixText: "Password :- ",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      labelText: "Enter Password",
                                    ),
                                    validator: (val) {},
                                    onChanged: (val) {
                                      upass = val;
                                    },
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                //color: Colors.lime,
                                child: SizedBox(
                                    height: 30,
                                    width: 100,
                                    child: FlatButton(
                                      onPressed: done,
                                      child: Text("Log In"),
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                    ))),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              //color: Colors.lime,
                              child: SizedBox(
                                  height: 45,
                                  width: 250,
                                  child: CheckboxListTile(
                                    value: check,
                                    onChanged: onchange,
                                    checkColor: Colors.black,
                                    activeColor: Colors.green,
                                    title: Text("Remember Me"),
                                  )),
                            ),
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                //color: Colors.lime,
                                child: SizedBox(
                                    height: 30,
                                    width: 120,
                                    child: FlatButton(
                                      color: Colors.lightGreen,
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Registration()));
                                      },
                                      //label: Text('Done'),
                                      child: Text("Registration"),
                                    ))),
                          ],
                        ),
                      ),
                      //color: Colors.lime,
                      margin: EdgeInsets.fromLTRB(
                          40, 0 /*it will change*/, 20, 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // color:Colors.green ,
        ),
      ]),
      appBar: AppBar(
        title: Text("Log In"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
    );
  }
}
