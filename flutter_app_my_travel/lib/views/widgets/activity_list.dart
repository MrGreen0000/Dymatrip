import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/views/widgets/activity_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activiies;
  final Function toogleActivity;
  final List<Activity> selectedActivities;

  const ActivityList({
    required this.activiies,
    required this.toogleActivity,
    required this.selectedActivities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: activiies
          .map(
            (activity) => ActivityCard(
              activity: activity,
              isSelected: selectedActivities.contains(activity),
              toogleActivity: () => toogleActivity(activity),
            ),
          )
          .toList(),
    );
  }
}
