import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/models/trip_model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/home/home_view.dart';
import 'package:my_travel/views/widgets/activity_list.dart';
import 'package:my_travel/views/widgets/trip_activity_list.dart';
import 'package:my_travel/views/widgets/trip_overview.dart';
import 'package:my_travel/widgets/dyma_drawer.dart';
import 'package:provider/provider.dart';

class CityView extends StatefulWidget {
  static const String routeName = '/city';

  const CityView({
    super.key,
  });

  showContext({required BuildContext context, required List<Widget> children}) {
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(
        children: children,
      );
    }
  }

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {
  late Trip mytrip;
  late int index;

  @override
  void initState() {
    super.initState();
    mytrip = Trip(
      activities: [],
      city: '',
      date: null,
    );
    index = 0;
  }

  double get amount {
    return mytrip.activities.fold(0.00, (prev, element) {
      return prev + element.price;
    });
  }

  void setDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toogleActivity(Activity activity) {
    setState(() {
      mytrip.activities.contains(activity)
          ? mytrip.activities.remove(activity)
          : mytrip.activities.add(activity);
    });
  }

  void deleteTripActivity(Activity activity) {
    setState(() {
      mytrip.activities.remove(activity);
    });
  }

  void saveTrip(String cityName) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Voulez vous sauvegarder ?'),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pop(context, 'save');
                  },
                  child: const Text(
                    'Sauvegarder',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
    if (mytrip.date == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Attention !'),
              content: const Text('Vous n\'avez pas entré de date'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ok'))
              ],
            );
          },
        );
      }
    } else if (result == 'save') {
      mytrip.city = cityName;
      if (mounted) {
        Provider.of<TripProvider>(context, listen: false).addTrip(mytrip);
        Navigator.pushNamed(context, HomeView.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation du voyage'),
      ),
      drawer: const DymaDrawer(),
      body: Container(
        child: widget.showContext(
          context: context,
          children: [
            TripOverview(
              setDate: setDate,
              myTrip: mytrip,
              cityName: city.name,
              amount: amount,
            ),
            Expanded(
                child: index == 0
                    ? ActivityList(
                        activiies: city.activities,
                        selectedActivities: mytrip.activities,
                        toogleActivity: toogleActivity,
                      )
                    : TripActivityList(
                        activities: mytrip.activities,
                        deleteTripActivity: deleteTripActivity,
                      )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveTrip(city.name);
        },
        child: const Icon(Icons.forward),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Découvert",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: "Mes activités",
          ),
        ],
        onTap: switchIndex,
      ),
    );
  }
}
