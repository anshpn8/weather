// //
// // class WeatherResponse {
// //   final Location location;
// //   final Current current;
// //   final Forecast forecast; // New field for forecast data, made nullable
// //
// //   WeatherResponse({
// //     required this.location,
// //     required this.current,
// //     required this.forecast, // Updated constructor
// //   });
// //
// //   factory WeatherResponse.fromJson(Map<String, dynamic> json) {
// //     return WeatherResponse(
// //       location: Location.fromJson(json['location']),
// //       current: Current.fromJson(json['current']),
// //       forecast: Forecast.fromJson(json['forecast']),
// //     );
// //   }
// // }
// //
// // class Location {
// //   final String name;
// //   final String region;
// //   final String country;
// //   final double lat;
// //   final double lon;
// //   final String tzId;
// //   final String localtime;
// //   final int time_epoch;
// //
// //   Location({
// //     required this.name,
// //     required this.region,
// //     required this.country,
// //     required this.lat,
// //     required this.lon,
// //     required this.tzId,
// //     required this.localtime,
// //     required this.time_epoch,
// //   });
// //
// //   factory Location.fromJson(Map<String, dynamic> json) {
// //     return Location(
// //       name: json['name'] as String,
// //       region: json['region'] as String,
// //       country: json['country'] as String,
// //       // API may return integers for lat/lon, use .toDouble() for consistency
// //       lat: (json['lat'] as num).toDouble(),
// //       lon: (json['lon'] as num).toDouble(),
// //       tzId: json['tz_id'] as String,
// //       localtime: json['localtime'] as String,
// //       time_epoch: json['localtime_epoch'] ?? 0,
// //     );
// //   }
// // }
// //
// // class Current {
// //   final double tempC;
// //   final double tempF;
// //   final int isDay;
// //   final Condition condition;
// //   final double windKph;
// //   final int humidity;
// //   final double feelsLikeC;
// //   final double feelsLikeF;
// //   final double uv;
// //   final double pressureMb;
// //   final double dewPoint;
// //   final String windDir;
// //   final double windChill;
// //   final int windDegree;
// //   final double visKm;
// //   final AirQualityData aqi;
// //
// //   Current({
// //     required this.tempC,
// //     required this.tempF,
// //     required this.isDay,
// //     required this.condition,
// //     required this.windKph,
// //     required this.humidity,
// //     required this.feelsLikeC,
// //     required this.feelsLikeF,
// //     required this.uv,
// //     required this.pressureMb,
// //     required this.dewPoint,
// //     required this.windDir,
// //     required this.windChill,
// //     required this.windDegree,
// //     required this.visKm,
// //     required this.aqi
// //   });
// //
// //   factory Current.fromJson(Map<String, dynamic> json) {
// //     return Current(
// //       // API may return integers for temperatures, use .toDouble() for consistency
// //       tempC: (json['temp_c'] ?? 0 as num).toDouble(),
// //       tempF: (json['temp_f'] ??  0 as num).toDouble(),
// //       isDay: json['is_day'] ?? 0,
// //       condition: Condition.fromJson(json['condition']),
// //       windKph: (json['wind_kph'] ?? 0 as num).toDouble(),
// //       humidity: json['humidity'] ?? 0 as int,
// //       feelsLikeC: (json['feelslike_c'] ?? 0 as num).toDouble(),
// //       feelsLikeF: (json['feelslike_f'] ?? 0 as num).toDouble(),
// //       uv: (json['uv'] ?? 0 as num).toDouble(),
// //       pressureMb: (json['pressure_mb'] ?? 0 as num).toDouble(),
// //       dewPoint: (json['dewpoint_c'] ?? 0 as num).toDouble(),
// //       windDir: json['wind_dir'] as String,
// //       windDegree: json['wind_degree'] ?? 0,
// //       windChill: (json['windchill_c'] ?? 0 as num).toDouble(),
// //       visKm: (json['vis_km'] ?? 0 as num).toDouble(),
// //       aqi: AirQualityData.fromJson(json['air_quality']),
// //     );
// //   }
// // }
// //
// // class Condition {
// //   final String text;
// //   final String icon;
// //   final int code;
// //
// //   Condition({
// //     required this.text,
// //     required this.icon,
// //     required this.code,
// //   });
// //
// //   factory Condition.fromJson(Map<String, dynamic> json) {
// //     return Condition(
// //       text: json['text'] as String,
// //       icon: json['icon'] as String,
// //       code: json['code'] as int,
// //     );
// //   }
// // }
// //
// // class Forecast {
// //   final List<ForecastDay> forecastday;
// //
// //   Forecast({required this.forecastday});
// //
// //   factory Forecast.fromJson(Map<String, dynamic> json) {
// //     final forecastDay = json['forecastday'];
// //
// //     if (forecastDay is! List) {
// //       return Forecast(forecastday: []);
// //     }
// //
// //     return Forecast(
// //       forecastday: forecastDay
// //           .map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
// //           .toList(),
// //     );
// //   }
// //
// //
// // }
// //
// // class ForecastDay {
// //   final Astro astro;
// //   final String date;
// //   final Day day;
// //   final double maxTemp;
// //   final double minTemp;
// //   final List<Hour> hours; // List of 24 hourly forecasts
// //
// //   ForecastDay({required this.date, required this.day,required this.maxTemp,required this.minTemp, required this.hours,required this.astro,});
// //
// //   factory ForecastDay.fromJson(Map<String, dynamic> json) {
// //     final hourData = json['hour'];
// //
// //
// //     // If hour is not a list, fallback to an empty list
// //     final hourList = hourData is List ? hourData : [];
// //
// //     return ForecastDay(
// //       date: json['date'] as String,
// //       day: Day.fromJson(json['day'] as Map<String, dynamic>),
// //       maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
// //       minTemp: (json['day']['mintemp_c'] as num).toDouble(),
// //       astro: Astro.fromJson(json['astro'] as Map<String, dynamic>),
// //       hours: hourList
// //           .map((e) => Hour.fromJson(e as Map<String, dynamic>))
// //           .toList(),
// //     );
// //   }
// //
// //
// // }
// //
// // class Day {
// //   final double maxtempC;
// //   final double mintempC;
// //   final Condition condition;
// //
// //   Day({required this.maxtempC, required this.mintempC, required this.condition});
// //
// //   factory Day.fromJson(Map<String, dynamic> json) {
// //     return Day(
// //       maxtempC: (json['maxtemp_c'] as num).toDouble(),
// //       mintempC: (json['mintemp_c'] as num).toDouble(),
// //       condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
// //     );
// //   }
// // }
// //
// // class Hour {
// //   final String time;
// //   final double tempC;
// //   final Condition condition;
// //   final double dewPoint;
// //   final int isDay;
// //   final AirQualityData aqi;
// //   final double chanceOfRain;
// //   final double chanceOfSnow;
// //   final double willItRain;
// //   final double willItSnow;
// //   final double visKm;
// //   final double humidity;
// //
// //   Hour({
// //     required this.time,
// //     required this.tempC,
// //     required this.condition,
// //     required this.dewPoint,
// //     required this.isDay,
// //     required this.aqi,
// //     required this.chanceOfRain,
// //     required this.chanceOfSnow,
// //     required this.willItRain,
// //     required this.willItSnow,
// //     required this.visKm,
// //     required this.humidity,
// //   });
// //
// //   factory Hour.fromJson(Map<String, dynamic> json) {
// //     return Hour(
// //       time: (json['time'] as String).split(' ')[1],
// //       tempC: (json['temp_c'] as num).toDouble(),
// //       condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
// //       dewPoint: (json['dewpoint_c'] ?? 0 as num).toDouble(),
// //       isDay: json['is_day'] as int,
// //       aqi: AirQualityData.fromJson(json['air_quality'] as Map<String, dynamic>),
// //       chanceOfRain: (json['chance_of_rain'] ?? 0 as num).toDouble(),
// //       chanceOfSnow: (json['chance_of_snow'] ?? 0 as num).toDouble(),
// //       willItRain: (json['will_it_rain'] ?? 0 as num).toDouble(),
// //       willItSnow: (json['will_it_snow'] ?? 0 as num).toDouble(),
// //       visKm: (json['vis_km'] ?? 0 as num).toDouble(),
// //       humidity: (json['humidity'] ?? 0 as num).toDouble(),
// //     );
// //   }
// // }
// //
// // class AirQualityData {
// //   final double co;
// //   final double no2;
// //   final double o3;
// //   final double so2;
// //   final double pm2_5;
// //   final double pm10;
// //   final int epaIndex;
// //   final int defraIndex;
// //
// //   AirQualityData({
// //     required this.co,
// //     required this.no2,
// //     required this.o3,
// //     required this.so2,
// //     required this.pm2_5,
// //     required this.pm10,
// //     required this.epaIndex,
// //     required this.defraIndex,
// //   });
// //
// //
// //   factory AirQualityData.fromJson(Map<String, dynamic> json) {
// //     return AirQualityData(
// //       co: (json["co"] ?? 0).toDouble(),
// //       no2: (json["no2"] ?? 0).toDouble(),
// //       o3: (json["o3"] ?? 0).toDouble(),
// //       so2: (json["so2"] ?? 0).toDouble(),
// //       pm2_5: (json["pm2_5"] ?? 0).toDouble(),
// //       pm10: (json["pm10"] ?? 0).toDouble(),
// //       epaIndex: json["us-epa-index"] ?? 0,
// //       defraIndex: json["gb-defra-index"] ?? 0,
// //     );
// //   }
// // }
// //
// //
// // // Data class to hold pollutant concentrations
// // class AirQualityIndex {
// //   final double co; // ug/m3 - needs conversion to ppm for EPA table
// //   final double no2; // ug/m3 - needs conversion to ppb for EPA table
// //   final double o3; // ug/m3 - needs conversion to ppb for EPA table
// //   final double so2; // ug/m3 - needs conversion to ppb for EPA table
// //   final double pm2_5; // ug/m3
// //   final double pm10; // ug/m3
// //
// //   AirQualityIndex({
// //     required this.co,
// //     required this.no2,
// //     required this.o3,
// //     required this.so2,
// //     required this.pm2_5,
// //     required this.pm10,
// //   });
// // }
// //
// // // Function to perform linear interpolation
// // double calculateAqi(
// //     double concentration,
// //     double bpLo,
// //     double bpHi,
// //     double iLo,
// //     double iHi,
// //     ) {
// //   if (concentration >= bpLo && concentration <= bpHi) {
// //     return ((iHi - iLo) / (bpHi - bpLo)) * (concentration - bpLo) + iLo;
// //   }
// //   return iHi;
// // }
// //
// // // Function to calculate individual pollutant AQI using EPA 2024 standards
// // int getPollutantAqi(String pollutant, double concentration) {
// //   // Breakpoints are listed as [BP_Lo, BP_Hi, I_Lo, I_Hi]
// //   List<List<double>> breakpoints = [];
// //
// //   switch (pollutant) {
// //     case 'PM2.5':
// //     // 24-hour standard (µg/m³)
// //       breakpoints = [
// //         [0.0, 12.0, 0.0, 50.0],
// //         [12.1, 35.4, 51.0, 100.0],
// //         [35.5, 55.4, 101.0, 150.0],
// //         [55.5, 150.4, 151.0, 200.0],
// //         [150.5, 250.4, 201.0, 300.0],
// //         [250.5, 500.4, 301.0, 500.0],
// //       ];
// //       break;
// //     case 'PM10':
// //     // 24-hour standard (µg/m³)
// //       breakpoints = [
// //         [0.0, 54.0, 0.0, 50.0],
// //         [55.0, 154.0, 51.0, 100.0],
// //         [155.0, 254.0, 101.0, 150.0],
// //         [255.0, 354.0, 151.0, 200.0],
// //         [355.0, 424.0, 201.0, 300.0],
// //         [425.0, 604.0, 301.0, 500.0],
// //       ];
// //       break;
// //     case 'O3':
// //     // 8-hour standard (ppb) - conversion 1 ppb ≈ 1.97 µg/m³
// //     // User data is in ug/m3, convert to ppb for EPA table
// //       concentration /= 1.97;
// //       breakpoints = [
// //         [0.0, 54.0, 0.0, 50.0],
// //         [55.0, 70.0, 51.0, 100.0],
// //         [71.0, 85.0, 101.0, 150.0],
// //         [86.0, 105.0, 151.0, 200.0],
// //         [106.0, 200.0, 201.0, 300.0],
// //         // Higher values exist for 1-hr O3
// //       ];
// //       break;
// //     case 'CO':
// //     // 8-hour standard (ppm) - conversion 1 ppm ≈ 1147 µg/m³
// //     // User data is in ug/m3, convert to ppm for EPA table
// //       concentration /= 1147.0;
// //       breakpoints = [
// //         [0.0, 4.4, 0.0, 50.0],
// //         [4.5, 9.4, 51.0, 100.0],
// //         [9.5, 12.4, 101.0, 150.0],
// //         [12.5, 15.4, 151.0, 200.0],
// //         [15.5, 30.4, 201.0, 300.0],
// //         [30.5, 40.4, 301.0, 400.0],
// //         [40.5, 50.4, 401.0, 500.0],
// //       ];
// //       break;
// //     case 'NO2':
// //     // 1-hour standard (ppb) - conversion 1 ppb ≈ 1.88 µg/m³
// //     // Note: This requires a 1-hour avg concentration. User data is likely 24hr,
// //     // but we use this as an example.
// //       concentration /= 1.88;
// //       breakpoints = [
// //         [0.0, 53.0, 0.0, 50.0], // Based on the annual standard for simplicity in ranges
// //         [54.0, 100.0, 51.0, 100.0], // 100 ppb is the 1-hr NAAQS
// //         [101.0, 360.0, 101.0, 150.0],
// //         [361.0, 649.0, 151.0, 200.0],
// //         [650.0, 1249.0, 201.0, 300.0],
// //         [1250.0, 1649.0, 301.0, 400.0],
// //         [1650.0, 2049.0, 401.0, 500.0],
// //       ];
// //       break;
// //     case 'SO2':
// //     // 24-hour standard (ppb) - conversion 1 ppb ≈ 2.62 µg/m³
// //     // User data is in ug/m3, convert to ppb for EPA table
// //       concentration /= 2.62;
// //       breakpoints = [
// //         [0.0, 35.0, 0.0, 50.0],
// //         [36.0, 75.0, 51.0, 100.0],
// //         [76.0, 185.0, 101.0, 150.0],
// //         [186.0, 304.0, 151.0, 200.0],
// //         [305.0, 604.0, 201.0, 300.0],
// //         // Higher values are 1-hr
// //       ];
// //       break;
// //     default:
// //       return 0; // Return 0 if pollutant is unknown
// //   }
// //
// //   // Iterate through breakpoints to find the correct range
// //   for (final bp in breakpoints) {
// //     double bpLo = bp[0];
// //     double bpHi = bp[1];
// //     double iLo = bp[2];
// //     double iHi = bp[3];
// //
// //     if (concentration >= bpLo && concentration <= bpHi) {
// //       // Use the helper function once the range is found
// //       return calculateAqi(concentration, bpLo, bpHi, iLo, iHi).round();
// //     }
// //   }
// //
// //   // If the concentration is higher than the max breakpoint (500 AQI), return max AQI value for that range
// //   if (concentration > breakpoints.last[1]) {
// //     return breakpoints.last[3].round();
// //   }
// //   return 0;
// // }
// //
// // class Astro {
// //   final SunInfo sun;
// //   final MoonInfo moon;
// //
// //   Astro({
// //     required this.sun,
// //     required this.moon,
// //   });
// //
// //   factory Astro.fromJson(Map<String, dynamic> json) {
// //     return Astro(
// //       sun: SunInfo(
// //         sunrise: json['sunrise'],
// //         sunset: json['sunset'],
// //         isSunUp: json['is_sun_up'] == 1,
// //       ),
// //       moon: MoonInfo(
// //         moonrise: json['moonrise'],
// //         moonset: json['moonset'],
// //         phase: json['moon_phase'],
// //         illumination: json['moon_illumination'],
// //         isMoonUp: json['is_moon_up'] == 1,
// //       ),
// //     );
// //   }
// // }
// //
// // class SunInfo {
// //   final String sunrise;
// //   final String sunset;
// //   final bool isSunUp;
// //
// //   SunInfo({
// //     required this.sunrise,
// //     required this.sunset,
// //     required this.isSunUp,
// //   });
// // }
// //
// // class MoonInfo {
// //   final String moonrise;
// //   final String moonset;
// //   final String phase;
// //   final int illumination;
// //   final bool isMoonUp;
// //
// //   MoonInfo({
// //     required this.moonrise,
// //     required this.moonset,
// //     required this.phase,
// //     required this.illumination,
// //     required this.isMoonUp,
// //   });
// // }
//
//
//
//
// class WeatherResponse {
//   final Location location;
//   final Current current;
//   final Forecast forecast;
//
//   WeatherResponse({
//     required this.location,
//     required this.current,
//     required this.forecast,
//   });
//
//   factory WeatherResponse.fromJson(Map<String, dynamic> json) {
//     return WeatherResponse(
//       location: Location.fromJson(json['location']),
//       current: Current.fromJson(json['current']),
//       forecast: Forecast.fromJson(json['forecast'] ?? {}),
//     );
//   }
// }
//
// class Location {
//   final String name;
//   final String region;
//   final String country;
//   final double lat;
//   final double lon;
//   final String tzId;
//   final String localtime;
//   final int time_epoch;
//
//   Location({
//     required this.name,
//     required this.region,
//     required this.country,
//     required this.lat,
//     required this.lon,
//     required this.tzId,
//     required this.localtime,
//     required this.time_epoch,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       name: json['name'] ?? '',
//       region: json['region'] ?? '',
//       country: json['country'] ?? '',
//       lat: (json['lat'] ?? 0).toDouble(),
//       lon: (json['lon'] ?? 0).toDouble(),
//       tzId: json['tz_id'] ?? '',
//       localtime: json['localtime'] ?? '',
//       time_epoch: json['localtime_epoch'] ?? 0,
//     );
//   }
// }
//
// class Current {
//   final double tempC;
//   final double tempF;
//   final int isDay;
//   final Condition condition;
//   final double windKph;
//   final int humidity;
//   final double feelsLikeC;
//   final double feelsLikeF;
//   final double uv;
//   final double pressureMb;
//   final double dewPoint;
//   final String windDir;
//   final double windChill;
//   final int windDegree;
//   final double visKm;
//   final AirQualityData aqi;
//
//   Current({
//     required this.tempC,
//     required this.tempF,
//     required this.isDay,
//     required this.condition,
//     required this.windKph,
//     required this.humidity,
//     required this.feelsLikeC,
//     required this.feelsLikeF,
//     required this.uv,
//     required this.pressureMb,
//     required this.dewPoint,
//     required this.windDir,
//     required this.windChill,
//     required this.windDegree,
//     required this.visKm,
//     required this.aqi,
//   });
//
//   factory Current.fromJson(Map<String, dynamic> json) {
//     return Current(
//       tempC: (json['temp_c'] ?? 0).toDouble(),
//       tempF: (json['temp_f'] ?? 0).toDouble(),
//       isDay: json['is_day'] ?? 0,
//       condition: Condition.fromJson(json['condition']),
//       windKph: (json['wind_kph'] ?? 0).toDouble(),
//       humidity: json['humidity'] ?? 0,
//       feelsLikeC: (json['feelslike_c'] ?? 0).toDouble(),
//       feelsLikeF: (json['feelslike_f'] ?? 0).toDouble(),
//       uv: (json['uv'] ?? 0).toDouble(),
//       pressureMb: (json['pressure_mb'] ?? 0).toDouble(),
//       dewPoint: (json['dewpoint_c'] ?? 0).toDouble(),
//       windDir: json['wind_dir'] ?? '',
//       windDegree: json['wind_degree'] ?? 0,
//       windChill: (json['windchill_c'] ?? 0).toDouble(),
//       visKm: (json['vis_km'] ?? 0).toDouble(),
//       aqi: AirQualityData.fromJson(json['air_quality'] ?? {}),
//     );
//   }
// }
//
// class Condition {
//   final String text;
//   final String icon;
//   final int code;
//
//   Condition({
//     required this.text,
//     required this.icon,
//     required this.code,
//   });
//
//   factory Condition.fromJson(Map<String, dynamic> json) {
//     return Condition(
//       text: json['text'] ?? '',
//       icon: json['icon'] ?? '',
//       code: json['code'] ?? 0,
//     );
//   }
// }
//
// class Forecast {
//   final List<ForecastDay> forecastday;
//
//   Forecast({required this.forecastday});
//
//   factory Forecast.fromJson(Map<String, dynamic> json) {
//     final fd = json['forecastday'];
//
//     return Forecast(
//       forecastday: fd is List
//           ? fd
//           .map((e) => ForecastDay.fromJson(e))
//           .toList()
//           : [],
//     );
//   }
// }
//
// class ForecastDay {
//   final Astro astro;
//   final String date;
//   final Day day;
//   final double maxTemp;
//   final double minTemp;
//   final List<Hour> hours;
//
//   ForecastDay({
//     required this.date,
//     required this.day,
//     required this.maxTemp,
//     required this.minTemp,
//     required this.hours,
//     required this.astro,
//   });
//
//   factory ForecastDay.fromJson(Map<String, dynamic> json) {
//     final hourList = json['hour'] ?? [];
//
//     return ForecastDay(
//       date: json['date'] ?? '',
//       day: Day.fromJson(json['day']),
//       maxTemp: (json['day']['maxtemp_c'] ?? 0).toDouble(),
//       minTemp: (json['day']['mintemp_c'] ?? 0).toDouble(),
//       astro: Astro.fromJson(json['astro']),
//       hours: hourList is List
//           ? hourList.map((e) => Hour.fromJson(e)).toList()
//           : [],
//     );
//   }
// }
//
// class Day {
//   final double maxtempC;
//   final double mintempC;
//   final Condition condition;
//
//   Day({required this.maxtempC, required this.mintempC, required this.condition});
//
//   factory Day.fromJson(Map<String, dynamic> json) {
//     return Day(
//       maxtempC: (json['maxtemp_c'] ?? 0).toDouble(),
//       mintempC: (json['mintemp_c'] ?? 0).toDouble(),
//       condition: Condition.fromJson(json['condition']),
//     );
//   }
// }
//
// class Hour {
//   final String time;
//   final double tempC;
//   final Condition condition;
//   final double dewPoint;
//   final int isDay;
//   final AirQualityData aqi;
//   final double chanceOfRain;
//   final double chanceOfSnow;
//   final double willItRain;
//   final double willItSnow;
//   final double visKm;
//   final double humidity;
//
//   Hour({
//     required this.time,
//     required this.tempC,
//     required this.condition,
//     required this.dewPoint,
//     required this.isDay,
//     required this.aqi,
//     required this.chanceOfRain,
//     required this.chanceOfSnow,
//     required this.willItRain,
//     required this.willItSnow,
//     required this.visKm,
//     required this.humidity,
//   });
//
//   factory Hour.fromJson(Map<String, dynamic> json) {
//     return Hour(
//       time: (json['time'] ?? '').split(' ').last,
//       tempC: (json['temp_c'] ?? 0).toDouble(),
//       condition: Condition.fromJson(json['condition']),
//       dewPoint: (json['dewpoint_c'] ?? 0).toDouble(),
//       isDay: json['is_day'] ?? 0,
//       aqi: AirQualityData.fromJson(json['air_quality'] ?? {}),
//       chanceOfRain: (json['chance_of_rain'] ?? 0).toDouble(),
//       chanceOfSnow: (json['chance_of_snow'] ?? 0).toDouble(),
//       willItRain: (json['will_it_rain'] ?? 0).toDouble(),
//       willItSnow: (json['will_it_snow'] ?? 0).toDouble(),
//       visKm: (json['vis_km'] ?? 0).toDouble(),
//       humidity: (json['humidity'] ?? 0).toDouble(),
//     );
//   }
// }
//
// //////////////////////////////////////////////////////////////
// // AIR QUALITY
// //////////////////////////////////////////////////////////////
//
// class AirQualityData {
//   final double co;
//   final double no2;
//   final double o3;
//   final double so2;
//   final double pm2_5;
//   final double pm10;
//   final int epaIndex;
//   final int defraIndex;
//
//   AirQualityData({
//     required this.co,
//     required this.no2,
//     required this.o3,
//     required this.so2,
//     required this.pm2_5,
//     required this.pm10,
//     required this.epaIndex,
//     required this.defraIndex,
//   });
//
//   factory AirQualityData.fromJson(Map<String, dynamic> json) {
//     return AirQualityData(
//       co: (json['co'] ?? 0).toDouble(),
//       no2: (json['no2'] ?? 0).toDouble(),
//       o3: (json['o3'] ?? 0).toDouble(),
//       so2: (json['so2'] ?? 0).toDouble(),
//       pm2_5: (json['pm2_5'] ?? 0).toDouble(),
//       pm10: (json['pm10'] ?? 0).toDouble(),
//       epaIndex: json['us-epa-index'] ?? 0,
//       defraIndex: json['gb-defra-index'] ?? 0,
//     );
//   }
// }
//
// //////////////////////////////////////////////////////////////
// // ASTRO
// //////////////////////////////////////////////////////////////
//
// class Astro {
//   final SunInfo sun;
//   final MoonInfo moon;
//
//   Astro({required this.sun, required this.moon});
//
//   factory Astro.fromJson(Map<String, dynamic> json) {
//     return Astro(
//       sun: SunInfo(
//         sunrise: json['sunrise'] ?? '',
//         sunset: json['sunset'] ?? '',
//         isSunUp: (json['is_sun_up'] ?? 0) == 1,
//       ),
//       moon: MoonInfo(
//         moonrise: json['moonrise'] ?? '',
//         moonset: json['moonset'] ?? '',
//         phase: json['moon_phase'] ?? '',
//         illumination: int.tryParse(json['moon_illumination'] ?? '0') ?? 0,
//         isMoonUp: (json['is_moon_up'] ?? 0) == 1,
//       ),
//     );
//   }
// }
//
// class SunInfo {
//   final String sunrise;
//   final String sunset;
//   final bool isSunUp;
//
//   SunInfo({
//     required this.sunrise,
//     required this.sunset,
//     required this.isSunUp,
//   });
// }
//
// class MoonInfo {
//   final String moonrise;
//   final String moonset;
//   final String phase;
//   final int illumination;
//   final bool isMoonUp;
//
//   MoonInfo({
//     required this.moonrise,
//     required this.moonset,
//     required this.phase,
//     required this.illumination,
//     required this.isMoonUp,
//   });
// }




import 'forecastmodel.dart';

class WeatherResponse {
  final LocationModel location;
  final CurrentModel current;
  final ForecastModel forecast;

  WeatherResponse({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      WeatherResponse(
        location: LocationModel.fromJson(json['location']),
        current: CurrentModel.fromJson(json['current']),
        forecast: ForecastModel.fromJson(json['forecast']),
      );
}


class LocationModel {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  LocationModel({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    name: json['name'],
    region: json['region'],
    country: json['country'],
    lat: (json['lat'] ?? 0).toDouble(),
    lon: (json['lon'] ?? 0).toDouble(),
    tzId: json['tz_id'],
    localtimeEpoch: json['localtime_epoch'],
    localtime: json['localtime'],
  );
}


class CurrentModel {
  final double tempC;
  final double tempF;
  final int isDay;
  final ConditionModel condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustMph;
  final double gustKph;
  final AirQualityModel airQuality;

  CurrentModel({
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    required this.airQuality,
  });

  factory CurrentModel.fromJson(Map<String, dynamic> json) => CurrentModel(
    tempC: (json['temp_c'] ?? 0).toDouble(),
    tempF: (json['temp_f'] ?? 0).toDouble(),
    isDay: json['is_day'] ?? 0,
    condition: ConditionModel.fromJson(json['condition']),
    windMph: (json['wind_mph'] ?? 0).toDouble(),
    windKph: (json['wind_kph'] ?? 0).toDouble(),
    windDegree: json['wind_degree'] ?? 0,
    windDir: json['wind_dir'] ?? '',
    pressureMb: (json['pressure_mb'] ?? 0).toDouble(),
    pressureIn: (json['pressure_in'] ?? 0).toDouble(),
    precipMm: (json['precip_mm'] ?? 0).toDouble(),
    precipIn: (json['precip_in'] ?? 0).toDouble(),
    humidity: json['humidity'] ?? 0,
    cloud: json['cloud'] ?? 0,
    feelslikeC: (json['feelslike_c'] ?? 0).toDouble(),
    feelslikeF: (json['feelslike_f'] ?? 0).toDouble(),
    windchillC: (json['windchill_c'] ?? 0).toDouble(),
    windchillF: (json['windchill_f'] ?? 0).toDouble(),
    heatindexC: (json['heatindex_c'] ?? 0).toDouble(),
    heatindexF: (json['heatindex_f'] ?? 0).toDouble(),
    dewpointC: (json['dewpoint_c'] ?? 0).toDouble(),
    dewpointF: (json['dewpoint_f'] ?? 0).toDouble(),
    visKm: (json['vis_km'] ?? 0).toDouble(),
    visMiles: (json['vis_miles'] ?? 0).toDouble(),
    uv: (json['uv'] ?? 0).toDouble(),
    gustMph: (json['gust_mph'] ?? 0).toDouble(),
    gustKph: (json['gust_kph'] ?? 0).toDouble(),
    airQuality: AirQualityModel.fromJson(json['air_quality']),
  );
}

