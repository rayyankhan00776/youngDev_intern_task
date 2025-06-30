import 'package:get/get.dart';
import '../models/book_model.dart';
import '../models/dashboard_state.dart';
import '../services/book_service.dart';

class DashboardViewModel extends GetxController {
  final BookService _bookService;
  final _state = DashboardState().obs;
  final RxList<Book> books = <Book>[].obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool showPopularBooks = true.obs;

  int _currentPage = 1;
  bool _hasMorePages = true;
  final Set<int> _loadedBookIds = <int>{};
  Category? _selectedCategory;

  DashboardViewModel({BookService? bookService})
    : _bookService = bookService ?? BookService();

  DashboardState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    loadInitialBooks();
  }

  Future<void> searchBooks(String query, {Category? category}) async {
    // Don't search if the query and category are the same
    if (query == _state.value.searchQuery && category == _selectedCategory)
      return;

    _state.value = _state.value.copyWith(
      searchQuery: query,
      status: DashboardStatus.loading,
    );
    _selectedCategory = category;

    // Reset states for new search
    _currentPage = 1;
    _hasMorePages = true;
    _loadedBookIds.clear();
    books.clear();

    try {
      final (newBooks, hasMore) = await _bookService.getBooks(
        search: query,
        searchType: _state.value.searchType,
        category: category,
        page: 1,
      );

      _hasMorePages = hasMore;

      if (newBooks.isNotEmpty) {
        books.addAll(newBooks);
        for (var book in newBooks) {
          _loadedBookIds.add(book.id);
        }
        _currentPage = 2;
      }

      _state.value = _state.value.copyWith(status: DashboardStatus.success);
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadInitialBooks() async {
    _state.value = _state.value.copyWith(
      status: DashboardStatus.loading,
      errorMessage: null,
    );

    try {
      // If there's a search query, use it
      if (_state.value.searchQuery.isNotEmpty) {
        await searchBooks(_state.value.searchQuery);
      } else if (showPopularBooks.value) {
        await _loadPopularBooks(refresh: true);
      } else {
        await _loadBooks(refresh: true);
      }

      _state.value = _state.value.copyWith(status: DashboardStatus.success);
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> togglePopularBooks() async {
    showPopularBooks.value = !showPopularBooks.value;
    await refreshBooks();
  }

  Future<void> refreshBooks() async {
    if (isLoadingMore.value) return;

    try {
      // Reset all states
      _currentPage = 1;
      _hasMorePages = true;
      _loadedBookIds.clear();
      books.clear();

      // Show loading state
      _state.value = _state.value.copyWith(status: DashboardStatus.loading);

      // Use random offset to get different books
      final randomOffset = DateTime.now().millisecondsSinceEpoch % 1000;
      final (newBooks, hasMore) = await _bookService.getBooks(
        page: randomOffset ~/ 20, // Use random page number
        search: _state.value.searchQuery,
        searchType: _state.value.searchType,
        category: _selectedCategory,
      );

      _hasMorePages = hasMore;

      if (newBooks.isNotEmpty) {
        books.addAll(newBooks);
        for (var book in newBooks) {
          _loadedBookIds.add(book.id);
        }
        _currentPage = (randomOffset ~/ 20) + 1;
      }

      _state.value = _state.value.copyWith(status: DashboardStatus.success);
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMoreBooks() async {
    if (isLoadingMore.value || !_hasMorePages) return;

    try {
      isLoadingMore.value = true;
      await _loadBooks();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadBooks({bool refresh = false}) async {
    try {
      final (newBooks, hasMore) = await _bookService.getBooks(
        page: _currentPage,
        search: _state.value.searchQuery,
        searchType: _state.value.searchType,
      );

      _hasMorePages = hasMore;

      final uniqueNewBooks =
          newBooks.where((book) {
            if (_loadedBookIds.contains(book.id)) {
              return false;
            }
            _loadedBookIds.add(book.id);
            return true;
          }).toList();

      if (uniqueNewBooks.isNotEmpty) {
        if (refresh) {
          books.clear();
        }
        books.addAll(uniqueNewBooks);
        _currentPage++;
      }
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> _loadPopularBooks({bool refresh = false}) async {
    try {
      final (newBooks, hasMore) = await _bookService.getPopularBooks(
        page: _currentPage,
      );

      _hasMorePages = hasMore;

      final uniqueNewBooks =
          newBooks.where((book) {
            if (_loadedBookIds.contains(book.id)) {
              return false;
            }
            _loadedBookIds.add(book.id);
            return true;
          }).toList();

      if (uniqueNewBooks.isNotEmpty) {
        if (refresh) {
          books.clear();
          _loadedBookIds.clear();
        }
        books.addAll(uniqueNewBooks);
        _currentPage++;
      }
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  void clearSearch() {
    _state.value = _state.value.copyWith(
      searchQuery: '',
      searchType: 'title',
      status: DashboardStatus.loading,
    );
    _selectedCategory = null;
    refreshBooks();
  }

  void toggleViewType() {
    _state.value = _state.value.copyWith(
      viewType:
          _state.value.viewType == ViewType.grid
              ? ViewType.list
              : ViewType.grid,
    );
  }

  void setSearchType(String type) {
    if (_state.value.searchType == type) return;
    _state.value = _state.value.copyWith(searchType: type);
    if (_state.value.searchQuery.isNotEmpty) {
      refreshBooks();
    }
  }

  void setCategory(Category? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    if (category != null) {
      searchBooks('', category: category);
    } else {
      refreshBooks();
    }
  }
}
