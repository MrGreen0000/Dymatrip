import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:http/http.dart' as http;

class TripProvider with ChangeNotifier {
  final String host = '192.168.1.36:80';
  List<Trip> _trips = [];

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

  Future<void> fetchData() async {
    try {
      http.Response response = await http.get(Uri.http(host, '/api/trips'));
      if (response.statusCode == 200) {
        _trips = (jsonDecode(response.body) as List)
            .map(
              (tripJson) => Trip.fromJson(tripJson),
            )
            .toList();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  Trip getById(String tripId) {
    return trips.firstWhere((trip) => trip.id == tripId);
  }

  void setActivityToDone(Activity activity) {
    activity.status = ActivityStatus.done;
    notifyListeners();
  }
}
