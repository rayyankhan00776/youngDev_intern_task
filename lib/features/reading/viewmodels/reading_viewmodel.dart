import 'package:get/get.dart';
import '../../dashboard/models/book_model.dart';
import '../models/reading_state.dart';
import '../services/reading_service.dart';

class ReadingViewModel extends GetxController {
  final Book book;
  final ReadingService _service;

  var state = ReadingState.loading().obs;
  // Set font size as a constant
  static const double fontSize = 14.0;

  ReadingViewModel(this.book, this._service);

  @override
  void onInit() {
    super.onInit();
    fetchBookContent();
  }

  void fetchBookContent() async {
    state.value = ReadingState.loading();
    try {
      // Build the plain text URL using the book's id
      final url = 'https://www.gutenberg.org/files/${book.id}/${book.id}-0.txt';
      final text = await _service.fetchBookText(url);
      state.value = ReadingState.loaded(text);
    } catch (e) {
      state.value = ReadingState.error('Failed to load book');
    }
  }
}
