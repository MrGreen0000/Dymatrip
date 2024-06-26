import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:my_travel/views/widgets/trip_overview_city.dart';

class TripOverview extends StatelessWidget {
  final VoidCallback setDate;
  final Trip myTrip;
  final String cityName;
  final String cityImage;
  final double amount;

  const TripOverview({
    required this.setDate,
    required this.myTrip,
    required this.cityName,
    required this.cityImage,
    required this.amount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;

    return Container(
      width:
          orientation == Orientation.landscape ? size.width * 0.5 : size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripOverviewCity(
            cityName: cityName,
            cityImage: cityImage,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.all(8)),
                Expanded(
                  child: Text(myTrip.date != null
                      ? DateFormat("d/M/y").format(myTrip.date!)
                      : "Sélectionner une date"),
                ),
                ElevatedButton(
                  onPressed: setDate,
                  child: const Text("Sélectionner une date"),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Montant / Personne",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Text(
                  '$amount€',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
