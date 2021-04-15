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

  final FirebaseFirestore db = FirebaseFirestore.instance;
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
      body: _buildBody(width, height),
    );
  }

  Widget _buildBody(double width, double height) {
    CollectionReference friendReq =
        db.collection('users').doc(uid).collection('friendReq');

    return StreamBuilder(
        stream: friendReq.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: Alignment.center, child: Text('Loading...'));
          }

          final documents = snapshot.data.docs;
          print(documents);

          return new ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = documents[index];

                return FutureBuilder<DocumentSnapshot>(
                    future:
                        db.collection('users').doc(document['ReqFromID']).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong.');
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff233141),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            alignment: Alignment.center,
                            height: height * 0.15,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: '${data['name']}',
                                          style: GoogleFonts.tajawal(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '\n${data['email']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: IconButton(
                                              icon: Icon(Icons.check),
                                              iconSize: 30,
                                              color: Colors.white,
                                              onPressed: () {
                                                db
                                                    .collection('users')
                                                    .doc(uid)
                                                    .collection('friendsList')
                                                    .add({
                                                  'friendId': snapshot.data.id
                                                }).then((value) {
                                                  db
                                                      .collection('users')
                                                      .doc(uid)
                                                      .collection('friendReq')
                                                      .where('ReqFromID',
                                                          isEqualTo:
                                                              snapshot.data.id)
                                                      .get()
                                                      .then((value) {
                                                    db
                                                        .collection('users')
                                                        .doc(uid)
                                                        .collection('friendReq')
                                                        .doc(
                                                            value.docs.first.id)
                                                        .delete();
                                                  });
                                                });

                                                db
                                                    .collection('users')
                                                    .doc(snapshot.data.id)
                                                    .collection('friendsList')
                                                    .add({
                                                  'friendId': uid
                                                }).then((value) {
                                                  print(value);
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              icon: Icon(Icons.cancel),
                                              iconSize: 30,
                                              color: Colors.white,
                                              onPressed: () {
                                                print('nay');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return Text('');
                    });
              });
        });
  }
}

// return new ListView.builder(
//     padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
//     itemCount: snapshot.data.docs.length,
//     itemBuilder: (context, index) {
//       DocumentSnapshot document = snapshot.data.docs[index];
//       db
//           .collection('users')
//           .doc(document['ReqFromID'])
//           .get()
//           .then((DocumentSnapshot snapshot) {
//         var friendName = snapshot.data()['name'].toString();
//         print(friendName);
//         var friendEmail = snapshot.data()['email'].toString();
//         print(friendEmail);
//       }).catchError((onError) {
//         print(onError);
//       });

// return Padding(
//   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//   child: Container(
//     decoration: BoxDecoration(
//       color: Color(0xff233141),
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//     ),
//     alignment: Alignment.center,
//     height: height * 0.15,
//     child: Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: width * 0.2,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: width * 0.4,
//             child: Container(
//               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//               child: RichText(
//                 text: TextSpan(
//                   text: '$friendName',
//                   style: GoogleFonts.tajawal(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '\n$friendEmail',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );
// });
