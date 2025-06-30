class Book {
  final int id;
  final String title;
  final List<Author> authors;
  final List<String> subjects;
  final Map<String, String> formats;
  final String? coverUrl;
  final int downloadCount; // Add download count

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.formats,
    this.coverUrl,
    required this.downloadCount,
  });

  String get cleanTitle {
    return title
        .replaceAll(
          RegExp(r'[^\w\s\-–—]'),
          '',
        ) // Remove special characters except dashes
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        ) // Replace multiple spaces with single space
        .trim();
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      authors:
          (json['authors'] as List)
              .map((author) => Author.fromJson(author))
              .toList(),
      subjects: List<String>.from(json['subjects']),
      formats: Map<String, String>.from(json['formats']),
      coverUrl: json['formats']['image/jpeg'],
      downloadCount: json['download_count'] as int? ?? 0,
    );
  }
}

class Author {
  final String name;
  String? _formattedName;

  Author({required this.name});

  String get formattedName {
    if (_formattedName != null) return _formattedName!;

    final parts = name.split(',');
    if (parts.length == 2) {
      final lastName = parts[0].trim();
      final firstName = parts[1].trim();
      _formattedName =
          '$firstName $lastName'
              .replaceAll(
                RegExp(r'[^\w\s\-]'),
                '',
              ) // Remove special characters except dashes
              .replaceAll(
                RegExp(r'\s+'),
                ' ',
              ) // Replace multiple spaces with single space
              .trim();
    } else {
      _formattedName =
          name
              .replaceAll(
                RegExp(r'[^\w\s\-]'),
                '',
              ) // Remove special characters except dashes
              .replaceAll(
                RegExp(r'\s+'),
                ' ',
              ) // Replace multiple spaces with single space
              .trim();
    }
    return _formattedName!;
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name'] as String);
  }
}
