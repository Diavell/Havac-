import 'package:flutter/material.dart';
import 'package:untitled8/resources/colors.dart';
import 'package:untitled8/widgets/art/rainy.dart';
import 'package:untitled8/widgets/weather_screen_model.dart';

import '../functions/weather.dart';

class RainyPage extends StatefulWidget {
  const RainyPage({Key? key}) : super(key: key);

  @override
  _RainyPageState createState() => _RainyPageState();
}

class _RainyPageState extends State<RainyPage> {
  WeatherPage weat = WeatherPage();
  late String admin = "a", des = "d", temp = "1", hum = "2", wind = "3";

  @override
  Widget build(BuildContext context) {
    /*weat.getLocation();
    admin = weat.adminArea.toString();
    des = weat.data.first.weatherDescription.toString();
    temp = weat.data.first.temperature.toString();
    hum = weat.data.first.humidity.toString();
    wind = weat.data.first.windSpeed.toString();*/

    return WeatherScreenModel(
        3, admin, CustomColors.rainBlue, des, const Rain(), temp, hum, wind);
  }
}
