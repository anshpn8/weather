import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pageView/home.dart';
import 'package:weather_app/utils/data_model/citySearchModel.dart';
import 'package:weather_app/utils/data_model/weatherboards.dart';
import 'package:weather_app/utils/services/service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppsFlyerService().initSdk();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    AppsFlyerService().logEvent("Opened", {
      "Description": "The Weather is opened."
    });

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CityProvider(
          )),
          ChangeNotifierProxyProvider<CityProvider, WeatherProvider>(
            create: (context) => WeatherProvider(context.read<CityProvider>()),
            update: WeatherProvider.update,
          ),
        ],
        child: const MyApp(),
      ),
    );
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent
        ),

      ),
      home: const MyHomePage(title: 'Weather App'),
      debugShowCheckedModeBanner: false,
    );
  }
}




