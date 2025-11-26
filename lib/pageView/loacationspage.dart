import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/data_model/citySearchModel.dart';

import '../utils/data_model/weatherboards.dart';
import '../utils/services/service.dart';



class LocationPage extends StatefulWidget{
  const LocationPage({super.key,});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>{
  bool rTMC=false;
  bool allSelected=false;

  List<bool> selected=[];

  @override
  void initState() {
    super.initState();
  }


  void _syncSelectionList(int length) {
    if (selected.length != length) {
      selected = List.generate(length, (index) {
        if (index < selected.length) {
          return selected[index];
        }
        return false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
       _syncSelectionList(provider.weatherDataList.length);
       return Scaffold(
          appBar: AppBar(
            // disappear the back arrow when rTMC is true
            leading: rTMC?SizedBox.shrink():null,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rTMC?Row(children: [Checkbox(
                  value: allSelected, onChanged: (value) {
                setState(() {
                  allSelected=!allSelected;
                  selected=provider.weatherDataList.map((e) => allSelected).toList();
                });
              }),
              allSelected?const Text("All selected"): Text(
                  selected.where((element) => element).isEmpty? "Select All":"${selected.where((element) => element).length }  Select")
              ],):const Text("Location"),
              rTMC?TextButton(onPressed: ()=> {
                setState(() {
                  rTMC=false;
                })
              }, child: Text("Cancel")):const Text(""),
            ],
          ),

        ),
          body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: provider.weatherDataList.length,
                itemBuilder: (context, index) {
                  final city = provider.weatherDataList[index];
                  return ListTile(
                    title: GestureDetector(
                      onLongPress: ()=>{
                        setState(() {
                          rTMC=true;
                        }),
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(
                                    85, 85, 85, 0.5058823529411764),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                rTMC? Checkbox(value: selected[index], onChanged: (value) {
                                  setState(() {
                                    selected[index]=!selected[index];
                                    allSelected=selected.every((element) => element);
                                  });
                                }):const Icon(Icons.location_on),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(city.city),
                                    Text("${city.region}, ${city.country}"),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox.square(dimension: 35,child: Image.network("https:${city.conditionIconUrl}"),),
                                Text("${city.temperature}℃"),
                              ],
                            ),
                          ],
                        ),),
                    ),

                  );
                }
              ),
              rTMC?IconButton(onPressed: (){
                setState(() {
                  List<int> toRemoveIndexes=[];
                  for (int i = 0; i < selected.length; i++) {
                    if (selected[i]) {

                      toRemoveIndexes.add(i);
                    }
                  }
                  final provider = Provider.of<CityProvider>(context, listen: false);
                  List<CityUseData> cities = provider.choosenCity;
                  AppsFlyerService().logEvent("CityRemoved", {
                    "Description": "${toRemoveIndexes.length} cities has been removed."
                  });
                  for (int i = 0; i < toRemoveIndexes.length; i++) {
                    provider.removeCity(cities[toRemoveIndexes[i]]);
                  }
                  allSelected=false;
                  rTMC=false;
                });
              }, icon: const Icon(Icons.delete)):const SizedBox()

            ],
          )
      ),
    );
      },
    );
  }
}