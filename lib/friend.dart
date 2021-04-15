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

  final FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _searchController = TextEditingController();

  String isSearched;
  QuerySnapshot searchResult;

  @override
  void initState() {
    super.initState();
    isSearched = 'NoSearch';
    _searchController.addListener(_searchTextChange);
  }

  _searchTextChange() {
    setState(() => isSearched = 'Searching');
  }

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
      body: Column(
        children: [
          _buildHeader(width, height),
          _buildBody(width, height, isSearched),
        ],
      ),
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
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintText: 'Enter a username here',
                                    hintStyle: GoogleFonts.sen(
                                      color: Colors.grey[700],
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  controller: _searchController,
                                  onSubmitted: (String value) {
                                    if (value != null) {
                                      db
                                          .collection('users')
                                          .where('email', isEqualTo: value)
                                          .get()
                                          .then((result) {
                                        if (result.size > 0 &&
                                            result.docs.first.id != uid) {
                                          setState(() {
                                            isSearched = 'Found';
                                            searchResult = result;
                                          });
                                        } else {
                                          setState(() {
                                            isSearched = 'None';
                                          });
                                        }
                                      }).catchError((onError) {
                                        setState(() => isSearched = 'None');
                                      });
                                    }
                                  },
                                ),
                              ),
                              _searchController.text.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.text = '';
                                              isSearched = 'NoSearch';
                                            });
                                          }),
                                    )
                                  : Container()
                            ],
                          ),
                        )),
                  ],
                ))
          ]))
    ]);
  }

  Widget _buildBody(double width, double height, String isSearched) {
    if (isSearched == 'Found' && searchResult != null) {
      String _resultId = searchResult.docs.first.id;
      String _resultName = searchResult.docs.first['name'];
      String _resultEmail = searchResult.docs.first['email'];
      String _resultTotalDistance =
          (searchResult.docs.first['totalDistance'] / 1000).toStringAsFixed(2);

      Future checkRequestedOrFriend() async {
        return FutureBuilder<QuerySnapshot>(
            future: db
                .collection('users')
                .doc(_resultId)
                .collection('friendReq')
                .where('ReqFromID', isEqualTo: uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.data.docs.length == 0) {
                return SizedBox(
                  width: width * 0.1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.person_add),
                      color: Colors.white,
                      onPressed: () {
                        db
                            .collection('users')
                            .doc(_resultId)
                            .collection('friendReq')
                            .add({
                          'ReqFromID': uid,
                        });
                      },
                    ),
                  ),
                );
              } else if (snapshot.data.docs.length == 1) {
                return SizedBox(
                    width: width * 0.1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(Icons.pending),
                    ));
              } else {
                return SizedBox(
                    width: width * 0.1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(Icons.done),
                    ));
              }
            });
      }

      return Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff233141),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            alignment: Alignment.center,
            height: height * 0.15,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.4,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          text: '$_resultName',
                          style: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\n$_resultEmail',
                            ),
                            TextSpan(
                              text: '\n$_resultTotalDistance KM',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  checkRequestedOrFriend()
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (isSearched == 'None' || isSearched == 'Searching') {
      return Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
          child: Text('No results found.'),
        ),
      );
    }

    return Expanded(
      child: Container(
        child: StreamBuilder(
            stream: db
                .collection('users')
                .doc(uid)
                .collection('friendsList')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                    alignment: Alignment.center, child: Text('Loading...'));

              final documents = snapshot.data.docs;

              return Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
                      child: Text('${documents.length} friends')),
                  Expanded(
                    child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = documents[index];

                          return FutureBuilder<DocumentSnapshot>(
                              future: db
                                  .collection('users')
                                  .doc(document['friendId'])
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong.');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                      snapshot.data.data();
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xff233141),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      alignment: Alignment.center,
                                      height: height * 0.15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width * 0.2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.4,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '${data['name']}',
                                                  style: GoogleFonts.tajawal(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n${data['email']}',
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '\n${data['totalDistance']}',
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
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
