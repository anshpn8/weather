import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/utils/constValue.dart';

class NewsWidget extends StatefulWidget{
  final List<NewsTiles> newsTiles;
  NewsWidget({super.key,required this.newsTiles});
  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  late List <NewsTiles> newsTiles;

  @override
  void initState() {
    newsTiles=widget.newsTiles;
    super.initState();
  }

  // Future<void> openArticle(int id) async {
  //
  //   final response = await httpClient.get(
  //     Uri.parse("https://news-matic.com/device/api/top-news?ref=android_app&clickid=123"),
  //     headers: {
  //       "Referer": "android_app",
  //       "User-Agent": "Flutter-Android"
  //     },
  //   );
  //
  //   String url="https://news-matic.com/details?id=$id";
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(
  //     uri,
  //     mode: LaunchMode.externalApplication, // opens default browser
  //   )) {
  //     throw Exception("Could not launch $url");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(112, 110, 110, 0.45),
      ),
      child: Column(
        children:
          [
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)],),
            ...List.generate(newsTiles.length, (index) => newsTiles[index])
          ]
      ),
    );
  }
}

class NewsTiles extends StatelessWidget{

  final httpClient = HttpClient();
  final String heading;
  final String image;
  final String id;
  NewsTiles({super.key, required this.heading, required this.image,required this.id});
  @override

  Future<void> openArticle(String id) async {

    final client = HttpClient();

    final request = await client.getUrl(
      Uri.parse("${ConstValue.forwardBaseurl}/device/api/top-news?ref=WeatherApp&pid=$id"),
    );
    request.headers.set("Referer", "android_app");
    request.headers.set("User-Agent", "Flutter-Android");

    final response = await request.close();
    final body = await response.transform(const Utf8Decoder()).join();

    print("API Response: $body");
    client.close();

    String url="${ConstValue.forwardBaseurl}/details?id=$id&ref=from_weatherApp";
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // opens default browser
    )) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => openArticle(id),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(12),
        //   color: const Color.fromRGBO(255, 128, 0, 0.45098039215686275),
        // ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(heading,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  ],
                )),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    image,
                    //loadingBuilder: (_, __, ___) =>CircularProgressIndicator(),
                    errorBuilder: (_, __, ___) => Icon(Icons.error),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}