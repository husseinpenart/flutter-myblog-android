import 'package:flutter/material.dart';

class TitleSplite extends StatelessWidget {
  final String title;
  final String? IconShape;
  final VoidCallback? onTap;
  const TitleSplite({
    super.key,
    required this.title,
    this.IconShape,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: (Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: 2),
          IconButton(
            iconSize: 40,
            icon: const Icon(
              Icons.more_horiz,
              color: Color.fromARGB(255, 24, 86, 255),
            ),
            tooltip: 'more ... ',
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
