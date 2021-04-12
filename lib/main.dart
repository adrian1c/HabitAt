import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'signup.dart';
import 'email_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //TODO: Make error display
          return Container(
              child: Text('Ooops', textDirection: TextDirection.ltr));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HabitAt',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: IntroScreen(),
          );
        }

        //TODO: Make loading screen
        return Container(
            child: Text(
          'Loading',
          textDirection: TextDirection.ltr,
        ));
      },
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    return new SplashScreen(
        navigateAfterSeconds:
            result != null ? Home(uid: result.uid) : EmailLogIn(),
        seconds: 5,
        title: new Text(
          'SPLISH SPLASH',
          style: GoogleFonts.roboto(
            color: Colors.white,
            letterSpacing: 15,
            fontWeight: FontWeight.normal,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xff233141),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.white);
  }
}
