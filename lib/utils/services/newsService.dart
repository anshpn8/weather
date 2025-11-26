import 'package:weather_app/utils/constValue.dart';
import 'package:weather_app/utils/data_model/newsarticle.dart';
import 'package:weather_app/utils/services/serviceApi.dart';

class NewsResponseData {

  late final List<NewsArticle> newsArticles;

  NewsResponseData({required this.newsArticles});

  NewsResponseData.fromJson(Map<String, dynamic> json) {
    final items = json['res'];

    if (items != null && items is List) {
      newsArticles = items
          .map((item) => NewsArticle.fromJson(item))
          .toList();
    } else {
      if(ConstValue.debug) print("⚠ WARNING: 'res' key is null or missing in API response");
      newsArticles = [];
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['articles'] = newsArticles.map((article) => article.toJson()).toList();
    return data;
  }
}


class NewsService extends API_Service{

  Map<String, dynamic> newsData = {};
  List<NewsArticle> newsArticle = [];

  // Future<List<NewsArticle>> fetchLatestNews() async {
  //   newsData = await fetchNews();
  //   return newsArticle;
  // }
  Future<List<NewsArticle>> fetchLatestNews() async {
    try {
      final newsArticles = await fetchNews();
      newsArticle = newsArticles;
      return newsArticle;
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

}