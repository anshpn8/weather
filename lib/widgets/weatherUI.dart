import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/data_model/newsarticle.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/widgets/newsWidget.dart';
import 'package:weather_app/widgets/sunsetRise.dart';
import 'package:weather_app/widgets/windDirectionWidget.dart';
import '../utils/services/weatherService.dart';
import '../widgets/aqiWidget.dart';
import '../widgets/forecast.dart';
import 'moonRise.dart';


class WeatherUI extends StatefulWidget {
  final List<NewsArticle> newsArticles;
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  Function refreshWeather;
  WeatherData weatherData;

  WeatherUI(
      {super.key,required this.newsArticles, required this.weatherData, required this.refreshWeather});

  @override
  State<WeatherUI> createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> {
  late WeatherData weatherData;
  late RefreshController refreshController;


@override
void initState() {
  super.initState();
  weatherData = widget.weatherData;
  refreshController = widget.refreshController;
}

  Widget _buildSmallCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String value,
        double progress = 0,
        bool showProgressBar = true,
      }) {
    final size = (MediaQuery.of(context).size.width - 50) / 2;
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(112, 110, 110, 0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 9,
            children: [
              Icon(icon, size: 30),
              Text(title),
            ],
          ),
          Text(subtitle),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),

          if (showProgressBar)
            LinearProgressIndicator(

              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              // gradient: LinearGradient(colors: Colors.blue.shade100,),
              borderRadius: BorderRadius.circular(12),
            ),
        ],
      ),
    );
  }

  String getVisibilityDescriptor(double visibilityMeters) {
    visibilityMeters *= 1000; // Convert to meters
    if (visibilityMeters > 40000.0) {
      return 'Excellent';
    } else if (visibilityMeters > 20000.0) { // 20,001–40,000 meters
      return 'Very Good';
    } else if (visibilityMeters > 10000.0) { // 10,001–20,000 meters
      return 'Good';
    } else if (visibilityMeters > 4000.0) { // 4,001–10,000 meters
      return 'Moderate';
    } else if (visibilityMeters > 1000.0) { // 1,001–4,000 meters
      return 'Poor';
    } else { // <= 1,000 meters
      return 'Very Poor';
    }
  }

  String uvDescription(double uv){
    if(uv<=2){
      return "Low";
    }
    else if(uv<=5){
      return "Moderate";
    }
    else if(uv<=7){
      return "High";
    }
    else if(uv<=10){
      return "Very High";
    }
    else{
      return "Extreme";
    }
  }

  @override
  Widget build(BuildContext context) {
  return  SmartRefresher(
    controller: refreshController,
    enablePullDown: true,
    onRefresh:()=> widget.refreshWeather(refreshController),
    header: WaterDropHeader(),

    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        // Background wrapper
        Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.pin_drop_sharp, size: 30), const SizedBox(width: 10),
                Text(weatherData.city,
                    style: const TextStyle(fontSize: 30)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    children: [
                      SizedBox.square(dimension: 55,child: Image.network("https:${weatherData.conditionIconUrl}"),),
                      Text(
                        weatherData.condition.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontSize: 30,
                        ),
                      ),
                    ]),

                Column(
                    children: [
                  Text(
                    '${weatherData.temperature}℃',
                    style: TextStyle(
                      color: Colors.blueGrey.shade900,
                      fontSize: 35,),
                  ),

                  Column(
                    children: [
                      Text("↑${weatherData.maxTemp}/↓${weatherData.minTemp}°"),
                      Text(" Feels Like ${weatherData.feelsLike}°"),
                    ],
                  ),
                ])


              ],
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(112, 110, 110, 0.45),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weatherData.conditionDescription,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      const Divider(color: Colors.black54),
                      // if (weatherData.hourlyForecast.isNotEmpty)
                      ForeCastList(weatherData.hourlyForecast),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallCard(
                  context,
                  icon: Icons.sunny,
                  title: "UV Index",
                  subtitle: "${uvDescription(weatherData.uv)} right now",
                  value: "${weatherData.uv}",
                  progress: weatherData.uv / 100,
                ),
                _buildSmallCard(
                  context,
                  icon: Icons.water_drop_sharp,
                  title: "Humidity",
                  subtitle: "",
                  value: "${weatherData.humidity}%",
                  progress: weatherData.humidity / 100,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallCard(
                  context,
                  icon: Icons.compress_sharp,
                  title: "Pressure",
                  subtitle: "Current Air Pressure",
                  value: "${weatherData.pressure} mb",
                  showProgressBar: false,
                ),
                _buildSmallCard(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  title: "Visibility",
                  subtitle: "${getVisibilityDescriptor(weatherData.visibility)} Right Now",
                  value: "1.50 KM",
                  showProgressBar: false,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.width -50) / 2,
                  width: (MediaQuery.of(context).size.width - 50) / 2,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(112, 110, 110, 0.45),
                  ),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.air_outlined),
                          const SizedBox(width: 10),
                          Text("Wind Dir: ${weatherData.windDir}")
                        ],
                      ),
                      SizedBox(height: 15,),
                      SizedBox.square(
                        dimension: 100,
                        child: WindDirectionIndicator(
                          speed: weatherData.windSpeed,
                          angle: weatherData.windDegree.toDouble(),
                        ),
                      )
                    ],
                  ),
                ),

                _buildSmallCard(
                  context,
                  icon: Icons.dew_point,
                  title: "Dew Point",
                  subtitle: "Noticeable Humidity",
                  value: "${weatherData.dewPoint}°",
                  showProgressBar: false,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(112, 110, 110, 0.45),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("AQI",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 12)),
                  const Text(
                    "Very High (10)",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                    const AlwaysStoppedAnimation(Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),
            SunArcWidget(
              astroModel: weatherData.astroModel,
              currentTime: DateTime.now(),
            ),
            MoonWidget(astroModel: weatherData.astroModel,),

            //const SizedBox(height: 20),

            GlassAirQualityCard(data: weatherData.aqi),

            //const SizedBox(height: 10),

            NewsWidget(
              newsTiles: List.generate(widget.newsArticles.length,
                      (index)=>
                      NewsTiles(heading: widget.newsArticles[index].uContent, image: widget.newsArticles[index].images, id: widget.newsArticles[index].pid)
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ],
    ),
  );
  }
}