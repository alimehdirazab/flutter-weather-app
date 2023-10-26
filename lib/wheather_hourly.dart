import 'package:flutter/material.dart';

class WeatherHourly extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const WeatherHourly(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 06,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 25,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(temperature),
            ],
          ),
        ),
      ),
    );
  }
}
