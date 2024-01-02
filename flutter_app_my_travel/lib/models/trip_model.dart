import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';

class Trip {
  String id;
  String city;
  List<Activity> activities;
  DateTime? date;

  Trip({
    required this.city,
    required this.activities,
    this.date,
  }) : id = UniqueKey().toString();
}
