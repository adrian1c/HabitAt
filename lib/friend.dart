import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'navigateDrawer.dart';
import 'friendReq.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key, @required this.uid}) : super(key: key);
  final String uid;
  @override
  _FriendPageState createState() => _FriendPageState(uid: uid);
}

class _FriendPageState extends State<FriendPage> {
  String uid;
  _FriendPageState({@required this.uid});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IconButton(
                icon: Icon(Icons.person_add),
                iconSize: 40,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendReqPage(uid: uid)),
                  );
                }),
          ),
        ],
      ),
      body: _buildHeader(width, height),
      drawer: NavigateDrawer(uid: uid),
    );
  }

  Column _buildHeader(double width, double height) {
    return Column(children: <Widget>[
      Container(
          width: width,
          height: height * 0.23,
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.2,
              decoration: BoxDecoration(
                color: Color(0xff233141),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
                child: Text(
                    'A companion a day, \nkeeps the cardiovascular diseases away.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.satisfy(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 65),
                      child: Text('Search...',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.sen(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    decoration: InputDecoration(
                                  hintText: 'Enter a username here',
                                  hintStyle: GoogleFonts.sen(
                                    color: Colors.grey[700],
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(Icons.search),
                              )
                            ],
                          ),
                        )),
                  ],
                ))
          ]))
    ]);
  }
}
