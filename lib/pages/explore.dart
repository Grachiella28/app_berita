import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/newscard.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExploreScreen> {
  final List<String> categories = [
    'Technology', 'Business', 'Science', 'Entertainment', 'Health', 'Sports'
  ];

  String? selectedCategory;
  List articles = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchNews() async {
    final query = _searchController.text.trim();
    final apiKey = '631af3f04d4548749cff2bbbb9bc5188';
    String url;

    setState(() => isLoading = true);

    if (query.isNotEmpty) {
      url =
          'https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&language=en&apiKey=$apiKey';
    } else if (selectedCategory != null) {
      url =
          'https://newsapi.org/v2/top-headlines?country=us&category=${selectedCategory!.toLowerCase()}&apiKey=$apiKey';
    } else {
      setState(() => isLoading = false);
      return;
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List filteredArticles = data['articles'];

      if (query.isNotEmpty && selectedCategory != null) {
        final lowerCategory = selectedCategory!.toLowerCase();
        filteredArticles = filteredArticles.where((article) {
          final title = article['title']?.toLowerCase() ?? '';
          final description = article['description']?.toLowerCase() ?? '';
          final source = article['source']['name']?.toLowerCase() ?? '';

          return title.contains(lowerCategory) ||
              description.contains(lowerCategory) ||
              source.contains(lowerCategory);
        }).toList();
      }

      setState(() {
        articles = filteredArticles;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to load news');
    }
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = null;
      } else {
        selectedCategory = category;
      }
    });
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Explore", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              onSubmitted: (_) => fetchNews(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for News',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Horizontal category filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => toggleCategory(cat),
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[800],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[300],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // News List
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (articles.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No articles found",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: articles[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
