import 'package:cloud_firestore/cloud_firestore.dart';

class RunSession {
  String key;
  final String date;
  final String time;
  double distance;
  String isStarted;
  int timerCounter;

  RunSession(this.date, this.time)
      : isStarted = 'notStarted',
        distance = 0.0,
        timerCounter = 0;

  toJson() {
    return {
      'date': date,
      'time': time,
      'distance': distance,
      'timerCounter': timerCounter,
      'isStarted': isStarted,
    };
  }
}
