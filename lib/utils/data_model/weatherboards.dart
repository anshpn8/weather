import 'package:flutter/material.dart';
import '../constValue.dart';
import '../services/weatherService.dart';
import 'citySearchModel.dart';

class WeatherProvider with ChangeNotifier {
  final CityProvider _cityProvider;

  List<WeatherData> _weatherDataList = [];
  bool isLoading = false;

  List<WeatherData> get weatherDataList => _weatherDataList;

  WeatherProvider(this._cityProvider) {
    // Calling it here handles the initial load when the app starts
    fetchWeatherDataForCities();
  }

  Future<void> fetchWeatherDataForCities() async {
    WeatherService _weatherService = WeatherService();
    isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    // Use a temporary list that we can use inside the try/catch
    List<WeatherData> tempFetchedData = [];
    final List<CityUseData> choosenCity = _cityProvider.choosenCity;
    try {
      final values = await Future.wait(
        choosenCity.map((city) =>
            _weatherService.fetchWeather("${city.name}, ${city.region}, ${city.country}")),
      );
      // Correctly assign the results of Future.wait to the temporary list
      tempFetchedData = values;
    } catch (error) {
      if (ConstValue.debug) print("Error fetching: $error");
    }

    // Assign the *actual* fetched data here (even if empty due to error/no cities)
    _weatherDataList = tempFetchedData;
    isLoading = false;
    notifyListeners(); // Notify UI that data is ready
  }

  static WeatherProvider update(
      BuildContext context, CityProvider cityProvider, WeatherProvider? previous) {
    // Re-run the fetch logic whenever the cityProvider changes
    final newProvider = previous ?? WeatherProvider(cityProvider);
    // Don't await here, let the function run asynchronously and notify listeners when done
    newProvider.fetchWeatherDataForCities();
    return newProvider;
  }
}
