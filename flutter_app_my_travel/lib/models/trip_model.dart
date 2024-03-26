import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';

class Trip {
  String id;
  String city;
  List<Activity> activities;
  DateTime? date;

  Trip(
      {required this.city,
      required this.activities,
      this.date,
      required this.id});

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        city = json['city'],
        date = DateTime.parse(json['date']),
        activities = (json['activities'] as List)
            .map((activityJson) => Activity.fromJson(activityJson))
            .toList();
}
