import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Folder {
  String id;
  String name;
  String userId;
  String description;
  List<String> listTopicId;

  Folder({
    required this.id,
    required this.name,
    required this.userId,
    required this.description,
    required this.listTopicId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userId': userId,
        'description': description,
        'listTopicId': listTopicId,
      };

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        id: json['id'],
        name: json['name'],
        userId: json['userId'],
        description: json['description'],
        listTopicId: List<String>.from(json['listTopicId']),
      );
}
