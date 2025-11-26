import 'package:flutter/material.dart';
import 'package:weather_app/utils/data_model/dataModel.dart';

import '../utils/data_model/forecastmodel.dart';


class ForeCastList extends StatelessWidget{
    final List<HourModel> hours;
    const ForeCastList(this.hours,{super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 130,
      child: hours.isNotEmpty? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];

          // Full icon URL (WeatherAPI icons come without protocol)
          final String iconUrl =
          hour.condition.icon.startsWith("http")
              ? hour.condition.icon
              : "https:${hour.condition.icon}";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🕒 Time
                Text(
                  hour.time.split(" ")[1],
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                ),
                const SizedBox(height: 5),

                // ☁️ Weather icon from network
                Image.network(iconUrl, width: 40, height: 40, fit: BoxFit.contain),

                const SizedBox(height: 5),

                // 🌡️ Temperature
                Text(
                  "${hour.tempC.toStringAsFixed(1)}℃",
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                ),
                const SizedBox(height: 5),

                // 💧 Dew Point
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.water_drop, size: 18),
                    Text(
                      "${hour.tempC}°",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ): Container() ,
    );
  }
}
