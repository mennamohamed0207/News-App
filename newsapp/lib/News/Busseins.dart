//for the API
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/News/Newsapi.dart';
import 'package:newsapp/News/Sports.dart';

import 'dart:convert';
import '../main.dart';
import 'NewsResponse.dart';
import 'package:flutter/foundation.dart';

class Busseins {
  static String _apiKey = "a4362ec633cb40049b124b15de6532f7";
  String _url =
      'https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=$_apiKey';
  Dio _dio = Dio();

  Future<List<Article>?> get fetchNewsArticleBuss async {
    try {
      Response response = await _dio.get(_url);
      BusseinsResponse newsResponse = BusseinsResponse.fromJson(response.data);
      return newsResponse.articles;
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}

//from the JSON file

class BusseinsResponse {
  BusseinsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory BusseinsResponse.fromJson(Map<String, dynamic> json) => BusseinsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );
}

class BusseinsPage extends StatelessWidget {
  const BusseinsPage({Key? key}) : super(key: key);

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
              title: const Text('Sports'),
              onTap: () {
               Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SportsPage(),
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
                "Busseins",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Article>?>(
                  future: Busseins().fetchNewsArticleBuss,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article>? newsArticle2 = snapshot.data;
                      return ListView.builder(
                        itemCount: newsArticle2?.length,
                        itemBuilder: (context, index) {
                          return NewsTile(article: newsArticle2![index]);
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

class BusseinsArticle extends Article {
  BusseinsArticle(
      {required super.source,
      required super.author,
      required super.title,
      required super.description,
      required super.url,
      required super.urlToImage,
      required super.publishedAt,
      required super.content});
}
