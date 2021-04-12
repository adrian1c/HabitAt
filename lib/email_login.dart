import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'email_signup.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
          appBar: AppBar(title: Text("Login")),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 20.0, bottom: 30.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome Back!',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\nWe\'ve missed you...',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 250,
                  height: 150,
                  child: Placeholder(
                    color: Colors.red,
                    strokeWidth: 2,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 15.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: 100, height: 40),
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
                                        if (_formKey.currentState.validate()) {
                                          setState(() => isLoading = true);
                                          logInToFb();
                                        }
                                      },
                                      child: Text('LOG IN',
                                          style: TextStyle(
                                              fontSize: 15,
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
                      )
                    ]))),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    onPressed: () => print('HELLO'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // TODO: Image(
                          //   image: AssetImage("assets/google_logo.png"),
                          //   height: 35.0,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'New around here?',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\nSign Up',
                                style: GoogleFonts.roboto(
                                  color: Colors.amber,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmailSignUp()));
                                  }),
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Forgot something?',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\nPassword',
                              style: GoogleFonts.roboto(
                                color: Colors.amber,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void logInToFb() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
      );
    }).catchError((err) {
      print(err.message);
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
}
