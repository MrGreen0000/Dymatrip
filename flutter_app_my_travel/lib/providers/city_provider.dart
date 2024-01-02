import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/data/data.dart' as data;

class CityProvider with ChangeNotifier {
  final List<City> _cities = data.cities;

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);
}
