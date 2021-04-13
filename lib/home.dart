import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:habitat/runSession.dart';

import 'navigateDrawer.dart';
import 'email_login.dart';
import 'session.dart';
import 'companion.dart';
import 'friend.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  Home({Key key, @required this.uid}) : super(key: key);
  final String uid;
  @override
  _HomeState createState() => _HomeState(uid: uid);
}

class _HomeState extends State<Home> {
  String uid;
  _HomeState({@required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Position _currentPosition;
  Position _previousPosition;
  StreamSubscription<Position> _positionStream;
  List<Position> _locations = [];
  var _totalDistance;

  RunSession _currentSession;
  var _totalDistanceAll;

  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  Future calculateDistance(FirebaseFirestore db, RunSession session) async {
    db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session.key)
        .get()
        .then((DocumentSnapshot snapshot) {
      _totalDistance = snapshot.data()['distance'].toDouble();
      print(_totalDistance);
    });
    db.collection('users').doc(uid).get().then((DocumentSnapshot snapshot) {
      _totalDistanceAll = snapshot.data()['totalDistance'].toDouble();
      print(_totalDistanceAll);
    });

    _positionStream = Geolocator.getPositionStream(
            distanceFilter: 10, desiredAccuracy: LocationAccuracy.best)
        .listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
            _locations.add(_currentPosition);

            if (_locations.length > 1) {
              _previousPosition = _locations.elementAt(_locations.length - 2);

              var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
                _previousPosition.latitude,
                _previousPosition.longitude,
                _currentPosition.latitude,
                _currentPosition.longitude,
              );
              _totalDistance += _distanceBetweenLastTwoLocations;
              _totalDistanceAll += _distanceBetweenLastTwoLocations;
              db
                  .collection('users')
                  .doc(uid)
                  .collection('sessions')
                  .doc(session.key)
                  .update({'distance': _totalDistance});

              db
                  .collection('users')
                  .doc(uid)
                  .update({'totalDistance': _totalDistanceAll});
              print('Total Distance: $_totalDistance');
            }
          });
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Make sure your GPS is on in Settings !'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              );
            });
      }
    });
  }

  Stream<int> stopWatchStream(RunSession session) {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    void endTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      db
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .doc(session.key)
          .update({'timerCounter': counter});
      streamController.add(counter);
    }

    void startTimer() {
      db
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .doc(session.key)
          .get()
          .then((DocumentSnapshot snapshot) {
        counter = snapshot.data()['timerCounter'];
      });
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: endTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  RunSession _startNewSession() {
    var _dateNow = DateTime.now().toString();
    List<String> _listDate = _dateNow.split(' ');
    _listDate.last = _listDate.last.substring(0, _listDate.last.indexOf('.'));
    RunSession runSession = new RunSession(_listDate.first, _listDate.last);
    db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .add(runSession.toJson())
        .then((value) {
      runSession.key = value.id;
      print(runSession.key);
    }).catchError((onError) => print(onError));

    return runSession;
  }

  Widget _buttonStates(currentSession, width, height) {
    //TODO: STYLING
    if (currentSession == null || currentSession.isStarted == 'Ended') {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: width * 0.7,
          height: height * 0.08,
          child: TextButton(
              child: Text('NEW SESSION',
                  style: TextStyle(color: Color(0xff134F15))),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(0xff134F15),
                      width: 7,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {
                RunSession newSession = _startNewSession();
                setState(() {
                  _currentSession = newSession;
                  hoursStr = '00';
                  minutesStr = '00';
                  secondsStr = '00';
                });
              }),
        ),
      );
    } else if (currentSession.isStarted == 'notStarted') {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: width * 0.7,
          height: height * 0.08,
          child: TextButton(
              child: Text('START'),
              style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all(Color(0xff134F15)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(0xff134F15),
                      width: 7,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {
                calculateDistance(db, currentSession);
                timerStream = stopWatchStream(currentSession);
                timerSubscription = timerStream.listen((int newTick) {
                  setState(() {
                    hoursStr = ((newTick / (60 * 60)) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    minutesStr = ((newTick / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    secondsStr =
                        (newTick % 60).floor().toString().padLeft(2, '0');
                  });
                });
                setState(() => _currentSession.isStarted = 'Started');
              }),
        ),
      );
    } else if (currentSession.isStarted == 'Started') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              width: width * 0.7,
              height: height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.38,
                    height: height * 0.08,
                    child: TextButton(
                        child: Text('PAUSE'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffB0C2DC),
                                width: 7,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _positionStream.pause();
                          timerSubscription.pause();
                          setState(() => _currentSession.isStarted = 'Paused');
                        }),
                  ),
                  Container(
                    width: width * 0.28,
                    height: height * 0.08,
                    child: TextButton(
                        child: Text('END'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffAE5541),
                                width: 7,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _positionStream.cancel();
                          timerSubscription.cancel();
                          db
                              .collection('users')
                              .doc(uid)
                              .collection('sessions')
                              .doc(currentSession.key)
                              .update({
                            'isStarted': 'Ended',
                          });
                          setState(() => _currentSession.isStarted = 'Ended');
                        }),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: db
                  .collection('users')
                  .doc(uid)
                  .collection('sessions')
                  .doc(currentSession.key)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');

                return Column(
                  children: [
                    Text('DISTANCE'),
                    Text(
                        '${(snapshot.data['distance'] / 1000).toStringAsFixed(3)} KM'),
                    Text('TIME'),
                    Text('$hoursStr:$minutesStr:$secondsStr'),
                  ],
                );
              }),
        ],
      );
    } else if (currentSession.isStarted == 'Paused') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              width: width * 0.7,
              height: height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.38,
                    height: height * 0.08,
                    child: TextButton(
                        child: Text('RESUME'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffF0DDCC),
                                width: 7,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _positionStream.resume();
                          timerSubscription.resume();
                          setState(() => _currentSession.isStarted = 'Started');
                        }),
                  ),
                  Container(
                    width: width * 0.28,
                    height: height * 0.08,
                    child: TextButton(
                        child: Text('END'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffAE5541),
                                width: 7,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _positionStream.cancel();
                          timerSubscription.cancel();
                          db
                              .collection('users')
                              .doc(uid)
                              .collection('sessions')
                              .doc(currentSession.key)
                              .update({
                            'isStarted': 'Ended',
                          });
                          setState(() => _currentSession.isStarted = 'Ended');
                        }),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: db
                  .collection('users')
                  .doc(uid)
                  .collection('sessions')
                  .doc(currentSession.key)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');

                return Column(
                  children: [
                    Text('DISTANCE'),
                    Text(
                        '${(snapshot.data['distance'] / 1000).toStringAsFixed(3)} KM'),
                    Text('TIME'),
                    Text('$hoursStr:$minutesStr:$secondsStr'),
                  ],
                );
              }),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text('OOPS'),
      );
    }
  }

  @override
  void dispose() {
    _positionStream.cancel();
    timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String uid = widget.uid;
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
            height: height * 0.2,
            decoration: BoxDecoration(
              color: Color(0xff29547B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(70.0),
              ),
            ),
            child: Text('Hello'),
          ),
          _buttonStates(_currentSession, width, height),
        ],
      ),
      drawer: NavigateDrawer(uid: uid),
    );
  }
}
