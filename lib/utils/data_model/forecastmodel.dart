
class ConditionModel {
  final String text;
  final String icon;
  final int code;

  ConditionModel({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      ConditionModel(
        text: json['text'],
        icon: json['icon'],
        code: json['code'],
      );
}

class AirQualityModel {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final int usEpaIndex;
  final int gbDefraIndex;

  AirQualityModel({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) =>
      AirQualityModel(
        co: (json['co'] ?? 0).toDouble(),
        no2: (json['no2'] ?? 0).toDouble(),
        o3: (json['o3'] ?? 0).toDouble(),
        so2: (json['so2'] ?? 0).toDouble(),
        pm2_5: (json['pm2_5'] ?? 0).toDouble(),
        pm10: (json['pm10'] ?? 0).toDouble(),
        usEpaIndex: json['us-epa-index'] ?? 0,
        gbDefraIndex: json['gb-defra-index'] ?? 0,
      );
}


class ForecastModel {
  final List<ForecastDayModel> forecastday;

  ForecastModel({required this.forecastday});

  factory ForecastModel.fromJson(Map<String, dynamic> json) => ForecastModel(
    forecastday: (json['forecastday'] as List)
        .map((e) => ForecastDayModel.fromJson(e))
        .toList(),
  );
}


class ForecastDayModel {
  final String date;
  final int dateEpoch;
  final DayModel day;
  final AstroModel astro;
  final List<HourModel> hour;

  ForecastDayModel({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) =>
      ForecastDayModel(
        date: json['date'],
        dateEpoch: json['date_epoch'],
        day: DayModel.fromJson(json['day']),
        astro: AstroModel.fromJson(json['astro']),
        hour:
        (json['hour'] as List).map((e) => HourModel.fromJson(e)).toList(),
      );
}


class DayModel {
  final double maxtempC;
  final double mintempC;
  final double avgtempC;
  final double maxwindKph;
  final int avghumidity;
  final ConditionModel condition;
  final double uv;

  DayModel({
    required this.maxtempC,
    required this.mintempC,
    required this.avgtempC,
    required this.maxwindKph,
    required this.avghumidity,
    required this.condition,
    required this.uv,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) => DayModel(
    maxtempC: (json['maxtemp_c'] ?? 0).toDouble(),
    mintempC: (json['mintemp_c'] ?? 0).toDouble(),
    avgtempC: (json['avgtemp_c'] ?? 0).toDouble(),
    maxwindKph: (json['maxwind_kph'] ?? 0).toDouble(),
    avghumidity: json['avghumidity'] ?? 0,
    condition: ConditionModel.fromJson(json['condition']),
    uv: (json['uv'] ?? 0).toDouble(),
  );
}


class AstroModel {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final int moonIllumination;

  AstroModel({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
  });

  factory AstroModel.fromJson(Map<String, dynamic> json) => AstroModel(
    sunrise: json['sunrise'],
    sunset: json['sunset'],
    moonrise: json['moonrise'],
    moonset: json['moonset'],
    moonPhase: json['moon_phase'],
    moonIllumination: json['moon_illumination'],
  );
}


class HourModel {
  final String time;
  final int timeEpoch;
  final double tempC;
  final double tempF;
  final int isDay;
  final ConditionModel condition;
  final int humidity;
  final double windKph;
  final double gustKph;
  final double uv;

  HourModel({
    required this.time,
    required this.timeEpoch,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.humidity,
    required this.windKph,
    required this.gustKph,
    required this.uv,
  });

  factory HourModel.fromJson(Map<String, dynamic> json) => HourModel(
    time: json['time'],
    timeEpoch: json['time_epoch'],
    tempC: (json['temp_c'] ?? 0).toDouble(),
    tempF: (json['temp_f'] ?? 0).toDouble(),
    isDay: json['is_day'],
    condition: ConditionModel.fromJson(json['condition']),
    humidity: json['humidity'] ?? 0,
    windKph: (json['wind_kph'] ?? 0).toDouble(),
    gustKph: (json['gust_kph'] ?? 0).toDouble(),
    uv: (json['uv'] ?? 0).toDouble(),
  );
}
