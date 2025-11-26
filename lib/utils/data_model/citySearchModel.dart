import 'package:flutter/material.dart';

import '../services/service.dart';


class CitySearchModel {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  CitySearchModel({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory CitySearchModel.fromJson(Map<String, dynamic> json) {
    return CitySearchModel(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      url: json['url'],
    );
  }
}


class CityUseData{
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  CityUseData({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });
}


class CityProvider extends ChangeNotifier {
  // DATA FIELD
  List<CityUseData> choosenCity = [ ];
    // CityUseData(name: "London", region: "England", country: "United Kingdom", lat: 51.5072, lon: -0.1,),

  CityProvider() {
    _init();
  }

  Future<void> _init() async {
    choosenCity = await LocationStore.loadCities();
    notifyListeners();
  }




  void addCity(CityUseData city) {
    choosenCity.add(city);
    LocationStore.saveCities(choosenCity);
    notifyListeners();   // tells UI to rebuild
  }

  void removeCity(CityUseData city) {
    choosenCity.remove(city);
    LocationStore.saveCities(choosenCity);
    notifyListeners();
  }

  int currentIndex = 0;
  void setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }

  List<CityUseData> getCities() {
    return choosenCity;
  }

}
