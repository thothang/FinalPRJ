class Word {
  String id;
  String term;
  String definition;
  String statusE; // Assuming this is a string
  bool isStar; // Assuming this is a boolean
  String topicId;

  Word({
    required this.id,
    required this.term,
    required this.definition,
    required this.statusE,
    required this.isStar,
    required this.topicId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'term': term,
        'definition': definition,
        'statusE': statusE,
        'isStar': isStar,
        'topicId': topicId,
      };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json['id'],
        term: json['term'],
        definition: json['definition'],
        statusE: json['statusE'],
        isStar: json['isStar'],
        topicId: json['topicId'],
      );
}
