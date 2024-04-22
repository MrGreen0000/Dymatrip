import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_travel/apis/google_api.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/place_model.dart';

Future showInputAutocomplete(BuildContext context) {
  return showDialog(context: context, builder: (_) => const InputAddress());
}

class InputAddress extends StatefulWidget {
  const InputAddress({super.key});

  @override
  State<InputAddress> createState() => _InputAddressState();
}

class _InputAddressState extends State<InputAddress> {
  late List<Place> _places = [];
  Timer? _debounce;

  Future<void> _searchAdress(String value) async {
    try {
      if (_debounce?.isActive == true && mounted) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () async {
        if (value.isNotEmpty) {
          _places = await getAutocompleteSuggestions(value);
          setState(() {});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {
      LocationActivity location = await getPlaceDetailsApi(placeId);
      if (mounted) {
        Navigator.pop(context, location);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Recherche"),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchAdress,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _places.length,
                itemBuilder: (_, i) {
                  var place = _places[i];
                  return ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(place.description),
                    onTap: () => getPlaceDetails(place.placeId),
                  );
                }),
          )
        ],
      ),
    );
  }
}
