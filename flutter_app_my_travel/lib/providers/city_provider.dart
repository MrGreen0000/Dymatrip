import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:http/http.dart' as http;

class CityProvider with ChangeNotifier {
  final String host = '192.168.1.36:80';
  List<City> _cities = [];

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  Future<void> fetchData() async {
    try {
      http.Response response = await http.get(Uri.http(host, '/api/cities'));
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
