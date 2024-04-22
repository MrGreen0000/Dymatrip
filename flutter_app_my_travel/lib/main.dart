import 'package:flutter/material.dart';

import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/activity_form/activity_form_view.dart';
import 'package:my_travel/views/not_found/not_found.dart';
import 'package:my_travel/views/city/city_view.dart';
import 'package:my_travel/views/home/home_view.dart';
import 'package:my_travel/views/trip/trip_view.dart';
import 'package:my_travel/views/trips/trips_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(const DymaTrip());

class DymaTrip extends StatefulWidget {
  const DymaTrip({super.key});

  @override
  State<DymaTrip> createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  final CityProvider cityProvider = CityProvider();
  final TripProvider tripProvider = TripProvider();

  @override
  void initState() {
    cityProvider.fetchData();
    tripProvider.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cityProvider),
        ChangeNotifierProvider.value(value: tripProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          HomeView.routeName: (_) => const HomeView(),
          CityView.routeName: (_) => const CityView(),
          TripsView.routeName: (_) => const TripsView(),
          TripView.routeName: (_) => const TripView(),
          ActivityFormView.routeName: (_) => const ActivityFormView()
        },
        onUnknownRoute: (_) =>
            MaterialPageRoute(builder: (_) => const NotFound()),
      ),
    );
  }
}
