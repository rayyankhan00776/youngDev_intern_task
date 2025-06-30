import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisperpages/features/notes/views/notes_fab.dart';
import '../../../login/viewmodels/login_viewmodel.dart';
import '../../models/dashboard_state.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/book_grid.dart';
import '../widgets/book_list.dart';
import '../widgets/search_bar.dart';

class DashboardPage extends StatelessWidget {
  final DashboardViewModel viewModel = Get.put(DashboardViewModel());

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Get.find<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text(
          'WhisperPages',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // Popular books toggle
          Obx(
            () => IconButton(
              icon: Icon(
                viewModel.showPopularBooks.value
                    ? Icons.trending_up
                    : Icons.explore_outlined,
                color:
                    viewModel.showPopularBooks.value
                        ? Theme.of(context).primaryColor
                        : null,
              ),
              onPressed: viewModel.togglePopularBooks,
              tooltip:
                  viewModel.showPopularBooks.value
                      ? 'Show All Books'
                      : 'Show Popular Books',
            ),
          ),
          // View type toggle
          Obx(
            () => IconButton(
              icon: Icon(
                viewModel.state.viewType == ViewType.grid
                    ? Icons.view_list
                    : Icons.grid_view,
              ),
              onPressed: viewModel.toggleViewType,
              tooltip:
                  viewModel.state.viewType == ViewType.grid
                      ? 'Show as List'
                      : 'Show as Grid',
            ),
          ),
          IconButton(
            onPressed: () => loginViewModel.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Obx(
            () => CustomSearchBar(
              onSearch: viewModel.searchBooks,
              onClear: viewModel.clearSearch,
              searchType: viewModel.state.searchType,
              onSearchTypeChanged: viewModel.setSearchType,
            ),
          ),
          // Section title
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    viewModel.showPopularBooks.value
                        ? 'Popular Books'
                        : viewModel.state.searchQuery.isNotEmpty
                        ? 'Search Results'
                        : 'All Books',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Book list/grid
          Expanded(
            child: Obx(() {
              if (viewModel.state.status == DashboardStatus.loading &&
                  viewModel.books.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.state.status == DashboardStatus.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.state.errorMessage ?? 'An error occurred',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: viewModel.refreshBooks,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.books.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      viewModel.state.searchQuery.isNotEmpty
                          ? 'No books found for "${viewModel.state.searchQuery}" ${viewModel.state.searchType != "title" ? "(${viewModel.state.searchType})" : ""}'
                          : 'No books available',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Obx(
                () =>
                    viewModel.state.viewType == ViewType.grid
                        ? BookGrid(
                          books: viewModel.books,
                          onLoadMore: viewModel.loadMoreBooks,
                          onRefresh: viewModel.refreshBooks,
                          isLoadingMore: viewModel.isLoadingMore.value,
                          status: viewModel.state.status,
                        )
                        : BookList(
                          books: viewModel.books,
                          onLoadMore: viewModel.loadMoreBooks,
                          onRefresh: viewModel.refreshBooks,
                          isLoadingMore: viewModel.isLoadingMore.value,
                        ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: NotesFloatingButton(
        userId: loginViewModel.user.value?.uid ?? '',
      ),
    );
  }
}
