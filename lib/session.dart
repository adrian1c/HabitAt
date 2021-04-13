import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'navigateDrawer.dart';
import 'home.dart';

class SessionPage extends StatefulWidget {
  SessionPage({Key key, @required this.uid}) : super(key: key);
  final String uid;
  @override
  _SessionPageState createState() => _SessionPageState(uid: uid);
}

class _SessionPageState extends State<SessionPage> {
  String uid;
  _SessionPageState({@required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffFBE4B8),
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xffC99531),
        title: Text('SESSIONS',
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
              color: Color(0xffC99531),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(70.0),
              ),
            ),
            child: Text('Hello'),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                  stream: db
                      .collection('users')
                      .doc(uid)
                      .collection('sessions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');

                    return new ListView.builder(
                        padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data.docs[index];

                          String date = document['date'];
                          String dateTime = document['time'];

                          double distance = document['distance'];

                          int time = document['timerCounter'];
                          String minutesStr = ((time / 60) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          String secondsStr =
                              (time % 60).floor().toString().padLeft(2, '0');

                          double pace = (distance / 1000) / (time / 3600);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(date,
                                          style: TextStyle(
                                            color: Color(0xff636363),
                                          )),
                                      Text(dateTime,
                                          style: TextStyle(
                                            color: Color(0xff636363),
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff636363),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    alignment: Alignment.center,
                                    height: height * 0.08,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width * 0.2,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'DISTANCE',
                                                  style: GoogleFonts.tajawal(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    letterSpacing: 2,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n${(distance / 1000).toStringAsFixed(2)}',
                                                      style:
                                                          GoogleFonts.spartan(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'KM',
                                                      style: GoogleFonts.sen(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.2,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'TIME',
                                                  style: GoogleFonts.tajawal(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    letterSpacing: 2,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n$minutesStr:$secondsStr',
                                                      style:
                                                          GoogleFonts.spartan(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.2,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'PACE',
                                                  style: GoogleFonts.tajawal(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    letterSpacing: 2,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n${pace < 100 && pace > 0 ? pace.toStringAsFixed(1) : '-'}',
                                                      style:
                                                          GoogleFonts.spartan(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'KM/H',
                                                      style: GoogleFonts.sen(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    )),
                              ],
                            ),
                          );
                        });
                  }),
            ),
          )
        ],
      ),
      drawer: NavigateDrawer(uid: uid),
    );
  }
}
