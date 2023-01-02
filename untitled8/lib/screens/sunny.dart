import 'package:flutter/material.dart';
import 'package:untitled8/resources/colors.dart';
import 'package:untitled8/resources/strings.dart';
import 'package:untitled8/widgets/art/sunny.dart';
import 'package:untitled8/widgets/weather_screen_model.dart';

class SunnyPage extends StatefulWidget {
  const SunnyPage({Key? key}) : super(key: key);

  @override
  _SunnyPageState createState() => _SunnyPageState();
}

class _SunnyPageState extends State<SunnyPage> {
  @override
  Widget build(BuildContext context) {
    return const WeatherScreenModel(
        1,
        AppStrings.provo,
        CustomColors.sunPink,
        AppStrings.cloudy,
        Sun(),
        AppStrings.newYorkTemp,
        AppStrings.provoHumidity,
        AppStrings.provoWindSpeed);
  }
}
