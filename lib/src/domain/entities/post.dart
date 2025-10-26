class Article {
  final String title;
  final String description;
  final String imagePath;
  final String writer;
  final String category;

  Article({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.writer,
    required this.category,
  });

  // New: Factory to create from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '', // Use ?? for defaults if null
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      writer: json['writer'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
