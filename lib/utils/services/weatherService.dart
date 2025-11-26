import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/constValue.dart';
import 'package:weather_app/utils/data_model/dataModel.dart';
import 'package:weather_app/utils/services/serviceApi.dart';

import '../data_model/citySearchModel.dart';
import '../data_model/forecastmodel.dart';

enum WeatherCondition { sunny, cloudy, rainy, snowy, thunderstorm, mist }


class WeatherData {
  final String city;
  final String country;
  final String region;
  final double temperature;
  final String condition;
  final String conditionDescription;
  final String conditionIconUrl;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final double pressure;
  final double dewPoint;
  final double uv;
  final double visibility;
  final int windDegree;
  final String windDir;
  final List<HourModel> hourlyForecast;
  final double maxTemp;
  final double minTemp;
  final AirQualityModel aqi;
  final int timeOfDay;
  final AstroModel astroModel;
  final String localtime;
  //final List<DailyForecast> dailyForecast;

  WeatherData({
    required this.city,
    required this.country,
    required this.region,
    required this.temperature,
    required this.condition,
    required this.conditionDescription,
    required this.conditionIconUrl,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.pressure,
    required this.dewPoint,
    required this.uv,
    required this.visibility,
    required this.windDegree,
    required this.windDir,
    required this.hourlyForecast,
    required this.maxTemp,
    required this.minTemp,
    required this.aqi,
    required this.astroModel,
    required this.timeOfDay,
    required this.localtime,
   // required this.dailyForecast,
  });
}

class HourlyForecast {
  final String time;
  final double temperature;
  final WeatherCondition condition;

  HourlyForecast({required this.time, required this.temperature, required this.condition});
}

class DailyForecast {
  final String day;
  final double maxTemp;
  final double minTemp;
  final WeatherCondition condition;

  DailyForecast({
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });
}


class WeatherService extends API_Service {

  Future<WeatherData> fetchWeather(String city) async {
    WeatherResponse weatherResponse = await fetchCurrentWeather(city: city);

    CurrentModel current = weatherResponse.current;
    LocationModel location = weatherResponse.location;

    final forecast = weatherResponse.forecast;
    if (forecast == null || forecast.forecastday.isEmpty) {
      throw Exception("Forecast data missing from API response");
    }

    return WeatherData(
      city: location.name,
      country: location.country,
      region: location.region,
      temperature: current.tempC,
      condition: current.condition.text,
      conditionDescription: current.condition.text,
      conditionIconUrl: current.condition.icon,
      humidity: current.humidity,
      windSpeed: current.windKph,
      feelsLike: current.feelslikeC,
      pressure: current.pressureMb,
      dewPoint: current.dewpointC,
      uv: current.uv,
      visibility: current.visKm,
      windDegree: current.windDegree,
      windDir: current.windDir,
      hourlyForecast: forecast.forecastday[0].hour,
      maxTemp: forecast.forecastday[0].day.maxtempC,
      minTemp: forecast.forecastday[0].day.mintempC,
      aqi: current.airQuality,
      astroModel: forecast.forecastday[0].astro,
      timeOfDay: location.localtimeEpoch,
      localtime: location.localtime
    );
  }

  Future<List<CitySearchModel>> searchCities(String query) async {

    List<CitySearchModel> resultsListcity=[];
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(
          "https://api.weatherapi.com/v1/search.json?key=${ConstValue.qwtk}&q=$query"));

      request.headers.set(HttpHeaders.userAgentHeader, "Flutter-WeatherApp");
      request.headers.set("Referer", "android_app");

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      final List data = json.decode(responseBody);

      resultsListcity = data.map((item) => CitySearchModel.fromJson(item)).toList();
    } catch (e) {
      // hasError = true;
    }
    finally{
      return resultsListcity;
    }
  }
}

/// Maps weather condition to a representative Icon.
IconData getWeatherIcon(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.sunny:
      return Icons.wb_sunny;
    case WeatherCondition.cloudy:
      return Icons.cloud;
    case WeatherCondition.rainy:
      return Icons.umbrella;
    case WeatherCondition.snowy:
      return Icons.ac_unit;
    case WeatherCondition.thunderstorm:
      return Icons.flash_on;
    case WeatherCondition.mist:
      return Icons.blur_on;
    }
}

/// Returns the descriptive string for the condition.
String getWeatherDescription(WeatherData data) {
  return data.conditionDescription;
}

/// Maps weather condition to a background gradient (dynamic theme).
List<Color> getWeatherGradient(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.sunny:
      return [const Color(0xFFFFA726), const Color(0xFFFFCC80)];
    case WeatherCondition.cloudy:
      return [const Color(0xFF78909C), const Color(0xFFCFD8DC)];
    case WeatherCondition.rainy:
      return [const Color(0xFF455A64), const Color(0xFF90A4AE)];
    case WeatherCondition.snowy:
      return [const Color(0xFFE0F7FA), const Color(0xFFB3E5FC)];
    case WeatherCondition.thunderstorm:
      return [const Color(0xFF263238), const Color(0xFF455A64)];
    case WeatherCondition.mist:
      return [const Color(0xFFB0BEC5), const Color(0xFFECEFF1)]; }
}


// dailyForecast: [
//   DailyForecast(day: 'Today', maxTemp: currentTempC + 5, minTemp: currentTempC - 3, condition: mainCondition),
//   DailyForecast(day: 'Wed', maxTemp: currentTempC + 4, minTemp: currentTempC - 4, condition: WeatherCondition.cloudy),
//   DailyForecast(day: 'Thu', maxTemp: currentTempC + 1, minTemp: currentTempC - 7, condition: WeatherCondition.rainy),
//   DailyForecast(day: 'Fri', maxTemp: currentTempC + 2, minTemp: currentTempC - 6, condition: WeatherCondition.sunny),
//   DailyForecast(day: 'Sat', maxTemp: currentTempC - 3, minTemp: currentTempC - 10, condition: WeatherCondition.snowy),
// ],