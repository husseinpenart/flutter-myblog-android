import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myblog/src/domain/entities/api_response.dart';

class ApiService {
  static const String _globalBlogEndpoint = '/GlobalBlog';
  static const int _defaultPageSize = 10;

  static Future<ApiResponse> fetchArticles({required int pageNumber, int pageSize = _defaultPageSize}) async {
    final String? baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      throw Exception('API_BASE_URL not set in .env');
    }

    final String url = '$baseUrl$_globalBlogEndpoint?pageNumber=$pageNumber&pageSize=$pageSize';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] != true) {
          throw Exception('API request failed: ${jsonResponse['message']}');
        }
        return ApiResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }
}