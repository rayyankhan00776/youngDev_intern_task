import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisperpages/features/notes/services/notes_service.dart';
import 'package:whisperpages/features/notes/viewmodels/notes_viewmodel.dart';
import 'package:whisperpages/features/notes/views/notes_page.dart';

class NotesFloatingButton extends StatelessWidget {
  final String userId;
  const NotesFloatingButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'notes_fab',
      backgroundColor: Colors.green,
      tooltip: 'Add/View Notes',
      onPressed: () {
        // Register the NotesViewModel with GetX so onInit is called
        Get.put(NotesViewModel(NotesService(), userId));
        Get.to(() => NotesPage());
      },
      child: const Icon(Icons.note_add, color: Colors.white),
    );
  }
}
