enum DashboardStatus { initial, loading, success, error }

enum ViewType { grid, list }

class Category {
  final String id;
  final String name;
  final String icon;
  final String topic;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.topic,
  });
}

class DashboardState {
  final DashboardStatus status;
  final String? errorMessage;
  final ViewType viewType;
  final String searchQuery;
  final String searchType;

  static const List<Category> categories = [
    Category(id: 'fiction', name: 'Fiction', icon: '📖', topic: 'fiction'),
    Category(
      id: 'non-fiction',
      name: 'Non-Fiction',
      icon: '📚',
      topic: 'biography',
    ),
    Category(
      id: 'classics',
      name: 'Classics',
      icon: '🏛️',
      topic: 'literature',
    ),
    Category(id: 'poetry', name: 'Poetry', icon: '🎭', topic: 'poetry'),
    Category(id: 'drama', name: 'Drama', icon: '🎪', topic: 'drama'),
    Category(
      id: 'philosophy',
      name: 'Philosophy',
      icon: '🤔',
      topic: 'philosophy',
    ),
    Category(id: 'history', name: 'History', icon: '⏳', topic: 'history'),
    Category(id: 'science', name: 'Science', icon: '🔬', topic: 'science'),
    Category(
      id: 'adventure',
      name: 'Adventure',
      icon: '🗺️',
      topic: 'adventure',
    ),
    Category(id: 'mystery', name: 'Mystery', icon: '🔍', topic: 'mystery'),
    Category(id: 'romance', name: 'Romance', icon: '💕', topic: 'love'),
  ];

  DashboardState({
    this.status = DashboardStatus.initial,
    this.errorMessage,
    this.viewType = ViewType.grid,
    this.searchQuery = '',
    this.searchType = 'title', // Default to title search
  });

  DashboardState copyWith({
    DashboardStatus? status,
    String? errorMessage,
    ViewType? viewType,
    String? searchQuery,
    String? searchType,
  }) {
    return DashboardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      viewType: viewType ?? this.viewType,
      searchQuery: searchQuery ?? this.searchQuery,
      searchType: searchType ?? this.searchType,
    );
  }
}
