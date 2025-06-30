import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisperpages/features/reading/services/reading_service.dart';
import '../../../dashboard/models/book_model.dart';

import 'package:whisperpages/features/reading/viewmodels/reading_viewmodel.dart';

class ReadingPage extends StatelessWidget {
  final Book book;
  ReadingPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final ReadingViewModel viewModel = Get.put(
      ReadingViewModel(book, ReadingService()),
      tag: book.id.toString(),
    );
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(book.cleanTitle),
        // Removed font size increase/decrease actions
      ),
      body: Obx(() {
        final state = viewModel.state.value;
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state.text != null) {
          // Clean the text: remove extra blank lines and unwanted symbols
          final cleanedText = state.text!
              // Remove all characters except a-z, A-Z, 0-9, ., !, and whitespace
              .replaceAll(RegExp(r'[^a-zA-Z0-9\.\!\s]'), '')
              // Replace 3 or more newlines with just 2
              .replaceAll(RegExp(r'\n{3,}'), '\n\n');
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: Text(
                  cleanedText,
                  style: TextStyle(
                    fontSize:
                        ReadingViewModel.fontSize, // Use constant font size
                    height: 1.6,
                    fontFamily: 'Georgia',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
