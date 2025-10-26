import 'package:flutter/material.dart';
import 'package:myblog/src/domain/entities/api_response.dart';
import 'package:myblog/src/domain/entities/post.dart';
import 'package:myblog/src/screens/detail_screen.dart';
import 'package:myblog/src/services/api_service.dart';
import 'package:myblog/src/widgets/article_card.dart';
import 'package:myblog/src/widgets/scroll_card.dart';
import 'package:myblog/src/widgets/title_splite.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> _articles = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _pageNumber = 1;
  int _totalPages = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !_isLoading &&
          !_isLoadingMore &&
          _pageNumber < _totalPages) {
        _fetchMoreArticles();
      }
    });
  }

  Future<void> _fetchArticles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _pageNumber = 1; // Reset to first page
      });
      final ApiResponse response = await ApiService.fetchArticles(
        pageNumber: _pageNumber,
      );
      setState(() {
        _articles = response.articles;
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      toastification.show(
        context: context,
        title: Text('Error: $e'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _fetchMoreArticles() async {
    try {
      setState(() => _isLoadingMore = true);
      final ApiResponse response = await ApiService.fetchArticles(
        pageNumber: _pageNumber + 1,
      );
      setState(() {
        _articles.addAll(response.articles);
        _totalPages = response.totalPages;
        _pageNumber++;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      toastification.show(
        context: context,
        title: Text('Error loading more: $e'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  void _onArticleTap(
    String title,
    String description,
    String imagePath,
    String writer,
    String category,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: title,
          description: description,
          imagePath: imagePath,
          writer: writer,
          category: category,
        ),
      ),
    );
  }

  void _showMore() {
    toastification.show(
      context: context,
      title: const Text("You selected the more button"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $_error'),
                  ElevatedButton(
                    onPressed: _fetchArticles,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchArticles,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: TitleSplite(
                        title: "Newest Blogs",
                        onTap: _showMore,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 255,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        children: _articles.map((article) {
                          return ArticleCard(
                            title: article.title,
                            description: article.description,
                            imagePath: article.imagePath,
                            writer: article.writer,
                            category: article.category,
                            onTap: () => _onArticleTap(
                              article.title,
                              article.description,
                              article.imagePath,
                              article.writer,
                              article.category,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: TitleSplite(title: "All Posts", onTap: _showMore),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ..._articles.map((element) {
                        return ScrollCard(
                          title: element.title,
                          imagePath: element.imagePath,
                          writer: element.writer,
                          description: element.description,
                          onTap: () => _onArticleTap(
                            element.title,
                            element.description,
                            element.imagePath,
                            element.writer,
                            element.category,
                          ),
                        );
                      }).toList(),
                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (_pageNumber >= _totalPages && _articles.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No more articles')),
                        ),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }
}
