import 'package:cloud_firestore/cloud_firestore.dart';

class UserResult {
  String id;
  String userId;
  int correctAnswers;
  DateTime date;
  int duration;
  int attempt;
  String mode; // Assuming this is a string

  UserResult({
    required this.id,
    required this.userId,
    required this.correctAnswers,
    required this.date,
    required this.duration,
    required this.attempt,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'correctAnswers': correctAnswers,
        'date': Timestamp.fromDate(date),
        'duration': duration,
        'attempt': attempt,
        'mode': mode,
      };

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
        id: json['id'],
        userId: json['userId'],
        correctAnswers: json['correctAnswers'],
        date: (json['date'] as Timestamp).toDate(),
        duration: json['duration'],
        attempt: json['attempt'],
        mode: json['mode'],
      );
}
