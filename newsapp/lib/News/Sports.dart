//for the API
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/News/Busseins.dart';
import 'package:newsapp/News/Newsapi.dart';

import 'dart:convert';
import '../main.dart';
import 'NewsResponse.dart';
import 'package:flutter/foundation.dart';

class Sports {
  static String _apiKey = "a4362ec633cb40049b124b15de6532f7";
  final String _url =
      "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$_apiKey";
  Dio _dio = Dio();

  Future<List<Article>?> get fetchNewsArticleSports async {
    try {
      Response response = await _dio.get(_url);
      SportsResponse newsResponse = SportsResponse.fromJson(response.data);
      return newsResponse.articles;
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}

class SportsResponse {
  SportsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory SportsResponse.fromJson(Map<String, dynamic> json) => SportsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );
}

class SportsArticle {
  SportsArticle({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  factory SportsArticle.fromJson(Map<String, dynamic> json) => SportsArticle(
        source: Source.fromJson(json["source"]),
        author: json["author"] == null ? null : json["author"],
        title: json["title"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"] == null ? null : json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] == null ? null : json["content"],
      );
}

class Source {
  Source({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
      );
}

class SportsPage extends StatelessWidget {
  const SportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(' '),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.money,
              ),
              title: const Text('Business'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusseinsPage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.computer,
              ),
              title: const Text('Technology'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sports",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Article>?>(
                  future: Sports().fetchNewsArticleSports,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article>? newsArticle = snapshot.data;
                      return ListView.builder(
                        itemCount: newsArticle?.length,
                        itemBuilder: (context, index) {
                          return NewsTile(article: newsArticle![index]);
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
