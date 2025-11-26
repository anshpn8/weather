import 'package:flutter/material.dart';
import 'package:weather_app/widgets/showmoon.dart';
import '../utils/data_model/forecastmodel.dart';

class MoonWidget extends StatelessWidget{
  final AstroModel astroModel;

  const MoonWidget({super.key, required this.astroModel});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(112, 110, 110, 0.45),
      ),
      child: Column(
        spacing: 10,
        children: [
          Text("Moon Phase", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
          MoonPhaseWidget(
              assetPath: 'assets/image/areal_moon.png',
              //assetPath: 'assets/image/fulldark.png',
              brightnessPercent: astroModel.moonIllumination.toDouble() ,
              litOnRight: 50 < astroModel.moonIllumination,
              size: 100,
              darknessOpacity: 0.72,
          ),
                  Text(astroModel.moonPhase),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Illumination: ${astroModel.moonIllumination}%", style: TextStyle(fontSize: 14,)),
                  Text("Rise:  ${astroModel.moonrise}", style: TextStyle(fontSize: 18,)),
                  Text("Set:    ${astroModel.moonset}", style: TextStyle(fontSize: 18,)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}