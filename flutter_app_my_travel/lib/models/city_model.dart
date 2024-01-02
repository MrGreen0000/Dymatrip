import 'package:my_travel/models/activity.model.dart';

class City {
  String image;
  String name;
  List<Activity> activities;
  City({
    required this.image,
    required this.name,
    required this.activities,
  });
}
