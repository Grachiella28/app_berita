import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/newscard.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bookmarks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada berita yang dibookmark'));
          }

          final bookmarks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final data = bookmarks[index].data() as Map<String, dynamic>;

              // Ubah agar bisa dipakai langsung oleh NewsCard
              final article = {
                'title': data['title'],
                'urlToImage': data['urlToImage'],
                'source': {'name': data['source']},
                'url': data['url'],
              };

              return NewsCard(article: article, likes: 0);
            },
          );
        },
      ),
    );
  }
}
