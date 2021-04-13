import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'navigateDrawer.dart';
import 'home.dart';

class FriendPage extends StatefulWidget {
  FriendPage({this.uid});
  final String uid;
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String uid = widget.uid;
    return Scaffold(
      backgroundColor: Color(0xffB1BCCA),
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xff233141),
        title: Text('FRIENDS',
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
            height: height * 0.2,
            decoration: BoxDecoration(
              color: Color(0xff233141),
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
