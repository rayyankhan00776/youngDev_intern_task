// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../reading/views/pages/reading_page.dart';
import '../../models/book_model.dart';

class BookList extends StatefulWidget {
  final List<Book> books;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;

  const BookList({
    super.key,
    required this.books,
    required this.onLoadMore,
    required this.onRefresh,
    required this.isLoadingMore,
  });

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final ScrollController _scrollController = ScrollController();
  bool _handleScrollNotification = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_handleScrollNotification) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _handleScrollNotification = false;
      widget.onLoadMore();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _handleScrollNotification = true;
        }
      });
    }
  }

  String _formatSubjects(Book book) {
    if (book.subjects.isEmpty) return '';
    final displaySubjects = book.subjects
        .where((subject) => subject.length < 30)
        .take(2)
        .map((subject) => subject.split(' -- ').first)
        .join(' • ');
    return displaySubjects;
  }

  Widget _buildCover(String? coverUrl) {
    return SizedBox(
      width: 70,
      height: 100,
      child:
          coverUrl != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholder(showProgress: true);
                  },
                ),
              )
              : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder({bool showProgress = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child:
            showProgress
                ? const CircularProgressIndicator()
                : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 32, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      'No Cover',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final book = widget.books[index];
                final subjects = _formatSubjects(book);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ReadingPage(book: book));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCover(book.coverUrl),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.cleanTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      height: 1.2,
                                    ),
                                  ),
                                  if (book.authors.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      book.authors.first.formattedName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        height: 1.1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                  if (subjects.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      subjects,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 1.1,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: widget.books.length),
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
