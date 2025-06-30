// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../models/dashboard_state.dart';
import 'book_card.dart';

class BookGrid extends StatefulWidget {
  final List<Book> books;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;
  final DashboardStatus status;

  const BookGrid({
    super.key,
    required this.books,
    required this.onLoadMore,
    required this.onRefresh,
    required this.isLoadingMore,
    required this.status,
  });

  @override
  _BookGridState createState() => _BookGridState();
}

class _BookGridState extends State<BookGrid> {
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth;
                    final cardHeight = constraints.maxHeight;
                    final coverHeight = cardHeight * 0.7;

                    return BookCard(
                      book: widget.books[index],
                      coverHeight: coverHeight,
                      cardWidth: cardWidth,
                    );
                  },
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
