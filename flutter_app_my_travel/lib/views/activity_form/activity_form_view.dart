import 'package:flutter/material.dart';
import 'package:my_travel/views/activity_form/widgets/activity_form.dart';
import 'package:my_travel/widgets/dyma_drawer.dart';

class ActivityFormView extends StatelessWidget {
  static const String routeName = '/activity-form';

  const ActivityFormView({super.key});

  @override
  Widget build(BuildContext context) {
    String? cityName = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ajouter une activité'),
      ),
      drawer: const DymaDrawer(),
      body: SingleChildScrollView(
        child: ActivityForm(cityName: cityName ?? ''),
      ),
    );
  }
}
