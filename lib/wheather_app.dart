import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheather_app/additional_info.dart';
import 'package:wheather_app/secret.dart';
import 'package:wheather_app/wheather_hourly.dart';
import 'package:http/http.dart' as http;

class WheatherApp extends StatefulWidget {
  const WheatherApp({Key? key}) : super(key: key);

  @override
  State<WheatherApp> createState() => _WheatherAppState();
}

class _WheatherAppState extends State<WheatherApp> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Karachi, PK';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$apiKey'),
      );

      final data = jsonDecode(res.body); // data?.cod
      if (data['cod'] != '200') {
        throw 'An unexpacted error occurred';
      }
      // data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          // '!' this sign at the end  says that it will not going to be null it works as hasData() function works

          final currentWeaterData = data['list'][0];
          final currentTemp = currentWeaterData['main']['temp'];
          final cuurentSky = currentWeaterData['weather'][0]['main'];

          final currentHumidity = currentWeaterData['main']['humidity'];
          final currentPressure = currentWeaterData['main']['pressure'];
          final currentWindSpeed = currentWeaterData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                cuurentSky == 'Clouds'
                                    ? Icons.cloud
                                    : cuurentSky == 'Rain'
                                        ? Icons.water_drop
                                        : Icons.sunny,
                                size: 45,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('$cuurentSky'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final time =
                          DateTime.parse(data['list'][0 + index]['dt_txt']);
                      final sky = data['list'][0 + index]['weather'][0]['main'];
                      final temp = data['list'][0 + index]['main']['temp'];

                      return WeatherHourly(
                        time: DateFormat.j().format(time),
                        icon: sky == 'Clouds'
                            ? Icons.cloud
                            : sky == 'Rain'
                                ? Icons.water_drop
                                : Icons.sunny,
                        temperature: '$temp K',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Additional Information'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop_rounded,
                      label: 'Humidity',
                      value: '$currentHumidity',
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
