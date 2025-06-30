import 'package:get/get.dart';
import '../models/note_model.dart';
import '../services/notes_service.dart';

class NotesViewModel extends GetxController {
  final NotesService _service;
  final String userId;

  var notes = <Note>[].obs;

  NotesViewModel(this._service, this.userId);

  @override
  void onInit() {
    super.onInit();
      print('Listening for notes for userId=$userId');
    _service.getNotesForUser(userId).listen((noteList) {
      notes.value = noteList;
    });
  }

  Future<void> addNote(String content) async {
    final note = Note(
      id: '',
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
    );
    await _service.addNote(note);
  }
}
