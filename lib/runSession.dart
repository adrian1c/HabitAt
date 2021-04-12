import 'package:cloud_firestore/cloud_firestore.dart';

class RunSession {
  String key;
  String date;
  String time;
  double distance;
  String isStarted;
  int timerCounter;

  RunSession(this.date, this.time)
      : isStarted = 'notStarted',
        distance = 0.0,
        timerCounter = 0;
}
