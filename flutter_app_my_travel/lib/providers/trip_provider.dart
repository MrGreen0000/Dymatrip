import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:my_travel/data/data.dart' as data;
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/trip_model.dart';

class TripProvider with ChangeNotifier {
  final List<Trip> _trips = data.trips;

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

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
