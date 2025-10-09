import 'package:flutter/material.dart';
import 'package:myblog/src/helper/blog_list.dart';
import 'package:myblog/src/widgets/article_card.dart';
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
      title: Text("You selected the more button"),
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
      body: Column(
        children: [
          SizedBox(
            child: TitleSplite(title: "Newest Blogs", onTap: _showrMore),
          ),
          SizedBox(
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
        ],
      ),
    );
  }
}
