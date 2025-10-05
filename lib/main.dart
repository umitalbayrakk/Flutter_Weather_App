import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/View/WeatherView/weather_view.dart';
import 'package:weather_app_flutter/View/WeatherView/weather_viewmodel.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => WeatherViewModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Weather App', home: const WeatherView());
  }
}
