import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'content': content, 'createdAt': createdAt};
  }
}
