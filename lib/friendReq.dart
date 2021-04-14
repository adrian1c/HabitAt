import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

class FriendReqPage extends StatefulWidget {
  FriendReqPage({Key key, @required this.uid}) : super(key: key);
  final String uid;
  @override
  _FriendReqPageState createState() => _FriendReqPageState(uid: uid);
}

class _FriendReqPageState extends State<FriendReqPage> {
  String uid;
  _FriendReqPageState({@required this.uid});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffB1BCCA),
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xff233141),
        title: Text('REQUESTS',
            textAlign: TextAlign.left,
            style: GoogleFonts.sen(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      body: Text('Hello'),
    );
  }
}
