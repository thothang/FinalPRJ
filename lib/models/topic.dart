import 'package:app/models/user_result.dart';
import 'package:app/models/word.dart';

class Topic {
  String id;
  String name;
  List<Word> listWords;
  bool mode; // Assuming mode is a boolean
  String author;
  String userId;
  List<UserResult> listUserResults;

  Topic({
    required this.id,
    required this.name,
    required this.listWords,
    required this.mode,
    required this.author,
    required this.userId,
    required this.listUserResults,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'listWords': listWords.map((word) => word.toJson()).toList(),
        'mode': mode,
        'author': author,
        'userId': userId,
        'listUserResults':
            listUserResults.map((result) => result.toJson()).toList(),
      };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'],
        name: json['name'],
        listWords: (json['listWords'] as List<dynamic>)
            .map((e) => Word.fromJson(e as Map<String, dynamic>))
            .toList(),
        mode: json['mode'],
        author: json['author'],
        userId: json['userId'],
        listUserResults: (json['listUserResults'] as List<dynamic>)
            .map((e) => UserResult.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Topic copyWith({
    String? id,
    String? name,
    List<Word>? listWords,
    bool? mode,
    String? author,
    String? userId,
    List<UserResult>? listUserResults,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      listWords: listWords ?? this.listWords,
      mode: mode ?? this.mode,
      author: author ?? this.author,
      userId: userId ?? this.userId,
      listUserResults: listUserResults ?? this.listUserResults,
    );
  }
}
