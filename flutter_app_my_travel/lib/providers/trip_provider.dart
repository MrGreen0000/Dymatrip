import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:http/http.dart' as http;

class TripProvider with ChangeNotifier {
  final String host = '192.168.1.36:80';
  List<Trip> _trips = [];
  bool isLoading = false;

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/trips'));
      if (response.statusCode == 200) {
        _trips = (jsonDecode(response.body) as List)
            .map(
              (tripJson) => Trip.fromJson(tripJson),
            )
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addTrip(Trip trip) async {
    try {
      http.Response response = await http.post(
        Uri.http(host, '/api/trip'),
        body: json.encode(trip.toJson()),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _trips.add(
          Trip.fromJson(
            json.decode(response.body),
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTrip(Trip trip, String activityId) async {
    try {
      Activity activity = trip.activities.firstWhere(
        (activity) => activity.id == activityId,
      );
      activity.status = ActivityStatus.done;

      http.Response response = await http.put(
        Uri.http(host, '/api/trips'),
        body: json.encode(
          trip.toJson(),
        ),
        headers: {"Content-type": "application/json"},
      );
      if (response.statusCode != 200) {
        activity.status = ActivityStatus.ongoing;
        throw const HttpException("Error");
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Trip getById(String tripId) {
    return trips.firstWhere((trip) => trip.id == tripId);
  }

  Activity getActivityByIds(
      {required String activityId, required String tripId}) {
    return getById(tripId)
        .activities
        .firstWhere((activity) => activity.id == activityId);
  }
}
