import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class CityProvider with ChangeNotifier {
  final String host = '192.168.1.36:80';
  List<City> _cities = [];
  bool isLoading = false;

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) => city.name.toLowerCase().startsWith(
                    filter.toLowerCase(),
                  ),
            )
            .toList(),
      );

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/cities'));
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      String cityId = getCityByName(newActivity.city).id!;
      http.Response response = await http.post(
          Uri.http(host, '/api/city/$cityId/activity'),
          headers: {'Content-type': 'application/json'},
          body: json.encode(newActivity.toJson()));
      if (response.statusCode == 200) {
        int index = _cities.indexWhere((city) => city.id == cityId);
        _cities[index] = City.fromJson(json.decode(response.body));
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> verifyIfActivityNameIsUnique(
      String cityName, String activityName) async {
    try {
      City city = getCityByName(cityName);
      http.Response response = await http.get(Uri.http(
          host, '/api/city/${city.id}/activities/verify/$activityName'));
      if (response.statusCode != 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File pickedImage) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.http(host, '/api/activity/image'),
      );

      request.files.add(
        http.MultipartFile.fromBytes("activity", pickedImage.readAsBytesSync(),
            filename: basename(pickedImage.path),
            contentType: MediaType('multipart', 'form-data')),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        print(responseData);
        print(
          String.fromCharCodes(responseData),
        );
        return json.decode(
          String.fromCharCodes(responseData),
        );
      } else {
        throw ('error');
      }
    } catch (e) {
      rethrow;
    }
  }
}
