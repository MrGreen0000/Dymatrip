import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/views/trip/widgets/trip_activity_list.dart';

class TripActivities extends StatelessWidget {
  final String tripId;

  const TripActivities({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                text: 'En cours',
              ),
              Tab(
                text: 'Terminé',
              ),
            ],
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TripActivityList(
                  tripId: tripId,
                  filter: ActivityStatus.ongoing,
                ),
                TripActivityList(
                  tripId: tripId,
                  filter: ActivityStatus.done,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
