import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constValue.dart';
import '../data_model/citySearchModel.dart';


class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;

  late AppsflyerSdk _appsflyerSdk;

  AppsFlyerService._internal() {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: ConstValue.afDevKey,
      appId: ConstValue.afAppId,
      showDebug: ConstValue.debug,
    );
    _appsflyerSdk = AppsflyerSdk(options);
  }

  Future<void> initSdk() async {
    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  void logEvent(String eventName, Map<String, dynamic> eventValues) {
    _appsflyerSdk.logEvent(eventName, eventValues);
  }
}

class LocationStore {
  static const String key = "saved_cities";

  static Future<void> saveCities(List<CityUseData> cities) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> encodedList = cities
        .map((city) => jsonEncode({
      'name': city.name,
      'region': city.region,
      'country': city.country,
      'lat': city.lat,
      'lon': city.lon,
    }))
        .toList();

    await prefs.setStringList(key, encodedList);
  }

  static Future<List<CityUseData>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? stored = prefs.getStringList(key);

    if (stored == null) return [];

    return stored.map((cityString) {
      final Map<String, dynamic> json = jsonDecode(cityString);
      return CityUseData(
        name: json['name'],
        region: json['region'],
        country: json['country'],
        lat: json['lat'],
        lon: json['lon'],
      );
    }).toList();
  }

  static Future<void> addCity(CityUseData city) async {
    List<CityUseData> list = await loadCities();
    list.add(city);
    await saveCities(list);
  }

  static Future<void> removeCityAt(int index) async {
    List<CityUseData> list = await loadCities();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveCities(list);
    }
  }

  static Future <void> removeCity(CityUseData city) async {
    List<CityUseData> list = await loadCities();
    list.remove(city);
    await saveCities(list);
  }


  static Future<void> clearCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

