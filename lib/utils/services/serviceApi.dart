import 'dart:convert';
import 'dart:io';

import 'package:weather_app/utils/constValue.dart';
import 'package:weather_app/utils/data_model/newsarticle.dart';
import 'package:weather_app/utils/services/newsService.dart';

import '../data_model/dataModel.dart';


class API_Service {
  static const String _baseUrl = ConstValue.baseUrl;

  final httpClient = HttpClient();

  Future<WeatherResponse> fetchCurrentWeather({required String city}) async {
    final Uri uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'key': ConstValue.qwtk,
      'q': city,
      'days': '1',
      'aqi': 'yes',
      'alerts': 'no',
    });

    try {
      final request = await httpClient.getUrl(uri);
      final httpResponse = await request.close();

      if (httpResponse.statusCode == 200) {
        final responseBody =
        await httpResponse.transform(utf8.decoder).join();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        return WeatherResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed: ${httpResponse.statusCode}');
      }
    } catch (e) {
      throw Exception("Weather error: $e");
    }
  }

  Future<List<NewsArticle>> fetchNews() async {
    final Uri uri = Uri.parse('https://news-matic.com/device/api/top-news');

    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        final newsResponse = NewsResponseData.fromJson(jsonResponse);
        return newsResponse.newsArticles;
      } else {
        throw Exception('Failed to load news data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}























