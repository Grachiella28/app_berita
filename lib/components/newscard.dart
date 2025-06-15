import 'package:flutter/material.dart';
import '../pages/newsdetail.dart'; // Pastikan ini benar sesuai struktur proyekmu

class NewsCard extends StatelessWidget {
  final Map article;
  final int likes;

  const NewsCard({
    Key? key,
    required this.article,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = article['urlToImage'] ??
        'https://via.placeholder.com/400x200.png?text=No+Image';
    final source = article['source']['name'] ?? 'Unknown Source';
    final title = article['title'] ?? 'No Title';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(article: article),
          ),
        );
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sumber
                  Text(
                    source,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Judul berita
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Like icon
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$likes',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
