import 'package:flutter/material.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/trips/widgets/trip_list.dart';
import 'package:my_travel/widgets/dyma_drawer.dart';
import 'package:my_travel/widgets/dyma_loader.dart';
import 'package:provider/provider.dart';

class TripsView extends StatelessWidget {
  static const String routeName = '/trips';

  const TripsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TripProvider tripProvider = Provider.of<TripProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes voyages'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'A venir',
              ),
              Tab(
                text: 'Passés',
              )
            ],
          ),
        ),
        drawer: const DymaDrawer(),
        body: tripProvider.isLoading != true
            ? tripProvider.trips.isNotEmpty
                ? TabBarView(
                    children: [
                      TripList(
                          trips: tripProvider.trips
                              .where(
                                  (trip) => DateTime.now().isBefore(trip.date!))
                              .toList()),
                      TripList(
                          trips: tripProvider.trips
                              .where(
                                  (trip) => DateTime.now().isAfter(trip.date!))
                              .toList()),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text("Aucun voyage pour le moment."),
                  )
            : const DymaLoader(),
      ),
    );
  }
}
