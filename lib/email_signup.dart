import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'email_login.dart';
import 'runSession.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3E4958), Color(0xff464277)])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text("Sign Up")),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 20.0, bottom: 30.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'I know, I know...',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\nThis will only take a moment!',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 230,
                            child: TextFormField(
                              controller: nameController,
                              style: TextStyle(color: Colors.grey[300]),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 0.0, left: 5.0),
                                labelText: "NAME",
                                labelStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.grey[900],
                                        offset: Offset(2.0, 2.0),
                                      )
                                    ]),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: ageController,
                              style: TextStyle(color: Colors.grey[300]),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 0.0, left: 5.0),
                                labelText: "AGE",
                                labelStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.grey[900],
                                        offset: Offset(2.0, 2.0),
                                      )
                                    ]),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Age';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.grey[300]),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 0.0, left: 5.0),
                            labelText: "EMAIL",
                            labelStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.grey[900],
                                    offset: Offset(2.0, 2.0),
                                  )
                                ]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter an Email Address';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          style: TextStyle(color: Colors.grey[300]),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 0.0, left: 5.0),
                            labelText: "PASSWORD",
                            labelStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.grey[900],
                                    offset: Offset(2.0, 2.0),
                                  )
                                ]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Password';
                            } else if (value.length < 6) {
                              return 'Password must be atleast 6 characters!';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: TextFormField(
                              obscureText: true,
                              controller: confirmPasswordController,
                              style: TextStyle(color: Colors.grey[300]),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 0.0, left: 5.0),
                                labelText: "CONFIRM PASSWORD",
                                labelStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.grey[900],
                                        offset: Offset(2.0, 2.0),
                                      )
                                    ]),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                              ),
                              validator: (value) {
                                if (value != passwordController.text) {
                                  return 'Not same';
                                }
                                return null;
                              })),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 80, height: 35),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffE7B76F)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)))),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() => isLoading = true);
                                              registerToFb();
                                            }
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 2.0,
                                                      color: Colors.grey[700],
                                                      offset: Offset(1.0, 1.0),
                                                    )
                                                  ],
                                                  letterSpacing: 3.0))),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailLogIn()));
                                    },
                                    child: Text(
                                      'BACK',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xffE7B76F),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey[900],
                                              offset: Offset(1.0, 1.0),
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ])))
              ],
            ),
          ),
        ));
  }

  void registerToFb() {
    double totalDistance = 0.0;
    List<RunSession> sessionList = [];
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      firestore.collection('users').doc(result.user.uid).set({
        'email': emailController.text,
        'age': ageController.text,
        'name': nameController.text,
        'sessions': sessionList,
        'totalDistance': totalDistance,
      }).then((res) {
        isLoading = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
  }
}
