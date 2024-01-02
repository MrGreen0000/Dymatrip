import 'package:flutter/material.dart';

import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/404/not_found.dart';
import 'package:my_travel/views/city/city_view.dart';
import 'package:my_travel/views/home/home_view.dart';
import 'package:my_travel/views/trip/trip_view.dart';
import 'package:my_travel/views/trips/trips_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(DymaTrip());

class DymaTrip extends StatefulWidget {
  // final List<City> cities = data.cities;

  const DymaTrip({super.key});

  @override
  State<DymaTrip> createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  // void addTrip(Trip trip) {
  //   setState(() {
  //     trips.add((trip));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CityProvider()),
        ChangeNotifierProvider.value(value: TripProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          HomeView.routeName: (_) => HomeView(),
          CityView.routeName: (_) => CityView(),
          TripsView.routeName: (_) => TripsView(),
          TripView.routeName: (_) => TripView(),
        },
        onUnknownRoute: (_) =>
            MaterialPageRoute(builder: (_) => const NotFound()),
      ),
    );
  }
}
