import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NotesService {
  final _notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
  }

  Stream<List<Note>> getNotesForUser(String userId) {
    return _notesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Note.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }
}
