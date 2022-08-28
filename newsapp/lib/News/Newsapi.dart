import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'NewsResponse.dart';

class NewsApiServices {
  static String _apiKey = "a4362ec633cb40049b124b15de6532f7";
  String _url =
      "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$_apiKey";
  Dio _dio = Dio();

  
  Future<List<Article>?>  get fetchNewsArticle   async {
    try {
      Response response = await _dio.get(_url);
      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles;
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
