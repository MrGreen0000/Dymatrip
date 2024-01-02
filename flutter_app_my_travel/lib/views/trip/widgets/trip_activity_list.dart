import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/trip/widgets/trip_activities.dart';
import 'package:provider/provider.dart';

class TripActivityList extends StatelessWidget {
  final String tripId;
  final ActivityStatus filter;

  const TripActivityList({
    super.key,
    required this.tripId,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      final Trip trip = Provider.of<TripProvider>(context).getById(tripId);
      final List<Activity> activities = trip.activities
          .where((activity) => activity.status == filter)
          .toList();
      return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, i) {
          Activity activity = activities[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: filter == ActivityStatus.ongoing
                ? Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    key: ValueKey(activity.id),
                    onDismissed: ((_) {
                      Provider.of<TripProvider>(context, listen: false)
                          .setActivityToDone(activity);
                    }),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          activity.name,
                        ),
                      ),
                    ),
                  )
                : Card(
                    child: ListTile(
                      title: Text(
                        activity.name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
          );
        },
      );
    });
  }
}
