import 'package:flutter/material.dart';
import 'package:myblog/src/helper/blog_list.dart';
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
  void _onArticleTap() {
    print("Article tapped!");
  }

  void _showrMore() {
    toastification.show(
      context: context,
      title: const Text("You selected the more button"),
      autoCloseDuration: const Duration(seconds: 5),
    );
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: TitleSplite(title: "Newest Blogs", onTap: _showrMore),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 255,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                children: articles.map((article) {
                  return ArticleCard(
                    title: article.title,
                    description: article.description,
                    imagePath: article.imagePath,
                    writer: article.writer,
                    category: article.category,
                    onTap: _onArticleTap,
                  );
                }).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: TitleSplite(title: "All Posts", onTap: _showrMore),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              articles.map((element) {
                return ScrollCard(
                  title: element.title,
                  imagePath: element.imagePath,
                  writer: element.writer,
                  description: element.description,
                  onTap: _onArticleTap,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
