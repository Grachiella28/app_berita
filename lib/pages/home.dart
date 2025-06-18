import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/newscard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=631af3f04d4548749cff2bbbb9bc5188');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
      });
    } else {
      print('Failed to fetch news: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'images/gnet.png', // Pastikan file ini ada di folder assets/images/
          height: 36,
        ),
      ),
      body: articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return NewsCard(article: article);
              },
            ),
    );
  }
}
