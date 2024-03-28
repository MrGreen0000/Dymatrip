import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_travel/widgets/dyma_loader.dart';

class TripWeather extends StatelessWidget {
  final String cityName;
  final String hostBase = 'https://api.openweathermap.org/data/2.5/weather?q=';
  final String apiKey = '&appid=758684b3587171521faca4080c23d85b';

  const TripWeather({super.key, required this.cityName});

  String get query => '$hostBase$cityName$apiKey';

  Future<String> get getWeather {
    return http.get(Uri.parse(query)).then((http.Response response) {
      Map<String, dynamic> body = json.decode(response.body);
      return body['weather'][0]['icon'] as String;
    }).catchError((e) => 'error');
  }

  String getUrlIcon(String iconName) {
    return 'https://openweathermap.org/img/wn/$iconName@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeather,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Meteo',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Image.network(
                    getUrlIcon(snapshot.data!),
                    width: 50,
                    height: 50,
                  )
                ],
              ),
            ),
          );
        } else {
          return const DymaLoader();
        }
      },
    );
  }
}
