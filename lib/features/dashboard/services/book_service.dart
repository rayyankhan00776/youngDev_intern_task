import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/dashboard_state.dart';

class BookService {
  static const String baseUrl = 'https://gutendex.com';
  final _random = Random();

  /// Get popular books sorted by download count
  Future<(List<Book>, bool)> getPopularBooks({int page = 1}) async {
    return getBooks(page: page, sortBy: 'popular');
  }

  Future<(List<Book>, bool)> getBooks({
    int page = 1,
    String? search,
    Category? category,
    String searchType = 'title',
    bool isRefresh = false,
    String sortBy = '',
  }) async {
    try {
      final queryParams = <String, String>{};

      // Add sorting parameter if specified
      if (sortBy.isNotEmpty) {
        queryParams['sort'] = sortBy;
      }

      // If refreshing without search, use random offset to get different books
      if (isRefresh && (search?.isEmpty ?? true) && category == null) {
        final randomOffset = _random.nextInt(1000);
        queryParams['offset'] = randomOffset.toString();
      } else {
        queryParams['page'] = page.toString();
      }

      // Handle category-based search
      if (category != null) {
        queryParams['topic'] = category.topic;
      }
      // Handle search-based queries
      else if (search != null && search.trim().isNotEmpty) {
        final searchTerm = search.trim();

        // First check if the search term matches a category
        final matchedCategory = DashboardState.categories.firstWhereOrNull(
          (cat) =>
              cat.name.toLowerCase() == searchTerm.toLowerCase() ||
              cat.topic.toLowerCase() == searchTerm.toLowerCase(),
        );

        if (matchedCategory != null) {
          // If it matches a category, use topic search
          queryParams['topic'] = matchedCategory.topic;
        } else {
          // Handle different search types
          switch (searchType.toLowerCase()) {
            case 'author':
              queryParams['author'] = searchTerm;
              break;
            case 'title':
              // Just use the search term directly for title searches
              queryParams['search'] = searchTerm;
              break;
            default:
              queryParams['search'] = searchTerm;
          }
        }
      }

      final uri = Uri.parse(
        '$baseUrl/books/',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        if (results.isEmpty) {
          return (<Book>[], false);
        }

        final books =
            results.map((bookJson) => Book.fromJson(bookJson)).toList();

        // If searching by title, do additional local filtering
        if (searchType == 'title' &&
            search != null &&
            search.trim().isNotEmpty) {
          final searchLower = search.trim().toLowerCase();
          books.sort((a, b) {
            final aTitleLower = a.title.toLowerCase();
            final bTitleLower = b.title.toLowerCase();

            // Exact matches first
            if (aTitleLower == searchLower) return -1;
            if (bTitleLower == searchLower) return 1;

            // Then starts with matches
            if (aTitleLower.startsWith(searchLower) &&
                !bTitleLower.startsWith(searchLower))
              return -1;
            if (bTitleLower.startsWith(searchLower) &&
                !aTitleLower.startsWith(searchLower))
              return 1;

            // Then contains matches
            if (aTitleLower.contains(searchLower) &&
                !bTitleLower.contains(searchLower))
              return -1;
            if (bTitleLower.contains(searchLower) &&
                !aTitleLower.contains(searchLower))
              return 1;

            return 0;
          });
        }

        final hasMorePages = data['next'] != null;
        return (books, hasMorePages);
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<Book> getBookById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/$id'));

      if (response.statusCode == 200) {
        return Book.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load book: $e');
    }
  }
}
