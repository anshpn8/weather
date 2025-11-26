import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/data_model/dataModel.dart';
import '../utils/data_model/forecastmodel.dart';

class GlassAirQualityCard extends StatelessWidget {
  final AirQualityModel data;

  const GlassAirQualityCard({super.key, required this.data});

  Color _aqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _aqiStatus(int aqi) {
    if (aqi <= 50) return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy (SG)";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  @override
  Widget build(BuildContext context) {
    final int aqi = data.usEpaIndex; // ← USE EPA index as AQI

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🌫️ Air Quality Index",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ---------------- AQI DISPLAY ----------------
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: _aqiColor(aqi).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _aqiColor(aqi)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "AQI (US EPA)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          aqi.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _aqiColor(aqi),
                          ),
                        ),
                        Text(
                          _aqiStatus(aqi),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _aqiColor(aqi),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _buildRow("CO", data.co),
              _buildRow("NO₂", data.no2),
              _buildRow("O₃", data.o3),
              _buildRow("SO₂", data.so2),
              _buildRow("PM2.5", data.pm2_5),
              _buildRow("PM10", data.pm10),

              const SizedBox(height: 10),
              Divider(color: Color.fromRGBO(255, 255, 255, 0.3)),
              const SizedBox(height: 10),

              _buildRow("US EPA Index", data.usEpaIndex),
              _buildRow("DEFRA Index", data.gbDefraIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

