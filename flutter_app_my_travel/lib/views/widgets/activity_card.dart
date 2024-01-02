import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isSelected;
  final VoidCallback toogleActivity;

  const ActivityCard({
    required this.activity,
    required this.isSelected,
    required this.toogleActivity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Ink.image(
            image: AssetImage(activity.image),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: toogleActivity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          activity.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
