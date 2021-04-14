import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'navigateDrawer.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.uid});
  final String uid;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String uid = widget.uid;
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEC5E5E),
        title: Text('PROFILE',
            textAlign: TextAlign.left,
            style: GoogleFonts.sen(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      body: _buildHeader(width, height),
      drawer: NavigateDrawer(uid: uid),
    );
  }

  Column _buildHeader(double width, double height) {
    return Column(children: <Widget>[
      Container(
          width: width,
          height: height * 0.3,
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.2,
              decoration: BoxDecoration(
                color: Color(0xffEC5E5E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.1),
                child: Text('John Cena\n@notjohncenaatallnope',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ))
          ]))
    ]);
  }
}
