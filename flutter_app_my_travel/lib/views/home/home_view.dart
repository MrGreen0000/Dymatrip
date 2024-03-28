import 'package:flutter/material.dart';

import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/views/widgets/city_card.dart';
import 'package:my_travel/widgets/dyma_drawer.dart';
import 'package:my_travel/widgets/dyma_loader.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CityProvider cityProvider = Provider.of<CityProvider>(context);
    List<City> filteredCities =
        cityProvider.getFilteredCities(searchController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('dymatrip'),
      ),
      drawer: const DymaDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          hintText: 'Rechercher une ville',
                          prefixIcon: Icon(Icons.search)),
                      onSubmitted: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: (() => setState(
                          () => searchController.clear(),
                        )),
                    icon: const Icon(Icons.clear),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: Provider.of<CityProvider>(context).fetchData,
                child: cityProvider.isLoading
                    ? const DymaLoader()
                    : filteredCities.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredCities.length,
                            itemBuilder: (_, i) => CityCard(
                              city: filteredCities[i],
                            ),
                          )
                        : const Text('Aucun resultat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
