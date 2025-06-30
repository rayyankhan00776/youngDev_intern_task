import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/book_model.dart';
import '../../../reading/views/pages/reading_page.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double coverHeight;
  final double cardWidth;

  const BookCard({
    super.key,
    required this.book,
    required this.coverHeight,
    required this.cardWidth,
  });

  String _formatSubjects() {
    if (book.subjects.isEmpty) return '';
    final displaySubjects = book.subjects
        .where((subject) => subject.length < 30)
        .take(2)
        .map((subject) => subject.split(' -- ').first)
        .join(' • ');
    return displaySubjects;
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _formatSubjects();

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: Colors.grey,
      color: Colors.white, // Set background color here
      child: SizedBox(
        width: cardWidth,
        height: coverHeight + 70,
        child: InkWell(
          onTap: () {
            Get.to(() => ReadingPage(book: book));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cover Image Section
              SizedBox(
                width: cardWidth,
                height: coverHeight,
                child: ColoredBox(
                  color: const Color(0xFFF5F5F5),
                  child:
                      book.coverUrl != null
                          ? Image.network(
                            book.coverUrl!,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.book,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                          )
                          : const Icon(
                            Icons.book,
                            size: 48,
                            color: Colors.grey,
                          ),
                ),
              ),
              // Book Info Section
              Expanded(
                child: Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Author
                      if (book.authors.isNotEmpty)
                        Text(
                          book.authors.map((a) => a.name).join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      // Subjects/Genre
                      if (subjects.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subjects,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
