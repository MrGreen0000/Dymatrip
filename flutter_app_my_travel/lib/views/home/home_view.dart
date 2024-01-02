import 'package:flutter/material.dart';

import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/views/widgets/city_card.dart';
import 'package:my_travel/widgets/dyma_drawer.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    List<City> cities = Provider.of<CityProvider>(context).cities;
    return Scaffold(
      appBar: AppBar(
        title: const Text('dymatrip'),
      ),
      drawer: const DymaDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ...cities.map(
            (city) {
              return CityCard(
                city: city,
              );
            },
          ).toList()
        ]),
      ),
    );
  }
}
