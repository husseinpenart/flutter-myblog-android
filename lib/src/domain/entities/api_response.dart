
import 'package:myblog/src/domain/entities/post.dart';

class ApiResponse {
  final List<Article> articles;
  final int totalPages;

  ApiResponse({required this.articles, required this.totalPages});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonList = json['data']['data'] ?? [];
    final articles = jsonList.map((json) => Article.fromJson(json)).toList();
    final totalPages = json['data']['totalPages'] ?? 1;
    return ApiResponse(articles: articles, totalPages: totalPages);
  }
}