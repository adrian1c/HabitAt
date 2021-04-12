import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'email_login.dart';
import 'session.dart';
import 'companion.dart';
import 'friend.dart';
import 'profile.dart';

class Home extends StatelessWidget {
  Home({this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffC2D3E8),
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xff29547B),
        title: Text('HOME',
            textAlign: TextAlign.left,
            style: GoogleFonts.sen(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: width,
            height: height * 0.25,
            decoration: BoxDecoration(
              color: Color(0xff29547B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(70.0),
              ),
            ),
            child: Text('Hello'),
          ),
        ],
      ),
      drawer: NavigateDrawer(uid: uid),
    );
  }
}

class NavigateDrawer extends StatefulWidget {
  final String uid;
  NavigateDrawer({Key key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data['email'],
                        style: GoogleFonts.spartan(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            accountName: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data['name'],
                        style: GoogleFonts.spartan(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            decoration: BoxDecoration(
              color: Color(0xff233141),
            ),
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(
              'HabitAt',
              style: GoogleFonts.spartan(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.library_books, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(
              'Sessions',
              style: GoogleFonts.spartan(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 2.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SessionPage(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.pets, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(
              'Companions',
              style: GoogleFonts.spartan(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 2.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompanionPage(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.people, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(
              'Friends',
              style: GoogleFonts.spartan(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 2.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendPage(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.face, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.spartan(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 2.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: widget.uid)),
              );
            },
          ),
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
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => EmailLogIn()),
                      (Route<dynamic> route) => false);
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.black87),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
