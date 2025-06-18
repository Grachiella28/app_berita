import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/newsdetail.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatefulWidget {
  final Map article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  void _checkIfBookmarked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final encodedUrl = widget.article['url'].replaceAll('/', '_');
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(encodedUrl)
        .get();

    setState(() {
      isBookmarked = doc.exists;
    });
  }

  Future<void> _toggleBookmark(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to bookmark')),
      );
      return;
    }

    final encodedUrl = widget.article['url'].replaceAll('/', '_');
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(encodedUrl);

    if (isBookmarked) {
      await docRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed')),
      );
    } else {
      final dataToSave = {
        'title': widget.article['title'] ?? '',
        'url': widget.article['url'] ?? '',
        'urlToImage': widget.article['urlToImage'] ?? '',
        'source.name': widget.article['source']?['name'] ?? '',
        'author': widget.article['author'],
        'description': widget.article['description'],
        'publishedAt': widget.article['publishedAt'],
        'content': widget.article['content'],
      };

      await docRef.set(dataToSave);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article bookmarked')),
      );
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final imageUrl = article['urlToImage'] ??
        'https://via.placeholder.com/400x200.png?text=No+Image';
    final title = article['title'] ?? 'No Title';
    final source = article['source']?['name'] ?? 'Unknown Source';

    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(article['publishedAt']);
      formattedDate = DateFormat('d MMMM y • HH:mm').format(dateTime);
    } catch (_) {
      formattedDate = 'Unknown Date';
    }

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
        color: Colors.black,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Berita
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            // Konten Teks
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
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
                  // Judul
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tanggal + Bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: () => _toggleBookmark(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
