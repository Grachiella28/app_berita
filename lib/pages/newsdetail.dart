import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  final Map article;

  const NewsDetailPage({super.key, required this.article});

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formatter = DateFormat('dd MMMM yyyy – HH:mm');
      return formatter.format(parsedDate);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          article['source']['name'] ?? 'News',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Berita
            if (article['urlToImage'] != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Image.network(
                  article['urlToImage'],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    article['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Author dan tanggal
                  Row(
                    children: [
                      if (article['author'] != null)
                        Text(
                          article['author'],
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Text(
                        formatDate(article['publishedAt'] ?? ''),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Deskripsi
                  if (article['description'] != null)
                    Text(
                      article['description'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  const SizedBox(height: 16),
                  // Konten
                  if (article['content'] != null)
                    Text(
                      article['content'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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
