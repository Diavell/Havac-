import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:untitled8/functions/toPascalCase.dart';
import 'package:untitled8/resources/colors.dart';

import '../functions/weather.dart';
import '../resources/fonts.dart';
import 'art/cloudy.dart';
import 'art/rainy.dart';
import 'art/sunny.dart';

class WeatherScreenModel extends StatefulWidget {
  final String condition;
  final String cityname;
  final Color bgColor;
  final Widget art;
  final String temperature;
  final String humidity;
  final String windSpeed;
  final int pagePosition;
  const WeatherScreenModel(this.pagePosition, this.cityname, this.bgColor,
      this.condition, this.art, this.temperature, this.humidity, this.windSpeed,
      {Key? key})
      : super(key: key);

  @override
  State<WeatherScreenModel> createState() => _WeatherScreenModelState();
}

class _WeatherScreenModelState extends State<WeatherScreenModel> {
  late AccelerometerEvent acceleration;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  int motionSensitivity = 4;

  String? adminArea, main, temp, hum, wind, des, info, infoDes;
  Color? backgroundColor;
  Widget? finalArt;
  WeatherPage weat = WeatherPage();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.MMMMd().format(DateTime.now());

  InterstitialAd? _ad;
  bool isLoaded = false;

  bool _showDialog = true;

  @override
  void initState() {
    reload();
    //ad();
    acceleration = AccelerometerEvent(0, 0, 0);
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_ad?.show();
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 550),
            top: acceleration.y * motionSensitivity,
            bottom: acceleration.y * -motionSensitivity,
            right: acceleration.x * -motionSensitivity,
            left: acceleration.x * motionSensitivity,
            child: Container(
              color: backgroundColor,
              child: Center(child: finalArt),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            top: acceleration.y * motionSensitivity,
            bottom: acceleration.y * motionSensitivity,
            right: acceleration.x * motionSensitivity,
            left: acceleration.x * -motionSensitivity,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    /*AlertDialog(
                        title: const Text("My title"),
                        content: const Text("This is my message."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                        ]),*/
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formattedDate,
                                    style: Fonts.titleTextTheme),
                                Text(adminArea.toString(),
                                    style: Fonts.titleTextTheme)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(main.toString(),
                                    style: Fonts.titleTextTheme
                                        .copyWith(fontSize: 40.0)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 15.0),
                            child: Text(
                              temp.toString(),
                              style: Fonts.largeConditionStyle,
                            ),
                          ),
                        )),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "${infoDes.toString()} ${info.toString()}",
                                  style: Fonts.detailedWeatherInfoStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Weather condition: ${des.toString().capitalize()}",
                                  style: Fonts.detailedWeatherInfoStyle,
                                ),
                              ),
                              /*Center(
                                    child: DotsIndicator(
                                  dotsCount: 3,
                                  position: double.tryParse(
                                      (widget.pagePosition - 1).toString())!,
                                  decorator: const DotsDecorator(activeColors: [
                                    CustomColors.sunOrange,
                                    CustomColors.cloudPink,
                                    CustomColors.raindropBlue
                                  ]),
                                ))*/
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reload() async {
    final deger = await weat.getWeather();
    if (deger.first.weatherMain.toString() == "Clouds") {
      setState(() {
        backgroundColor = CustomColors.cloudGrey;
        finalArt = const Clouds();
        info = deger.first.cloudiness.toString();
        infoDes = "Cloudiness: ";
      });
    }
    if (deger.first.weatherMain.toString() == "Clear") {
      setState(() {
        backgroundColor = CustomColors.sunPink;
        finalArt = const Sun();
        info = deger.first.tempFeelsLike.toString();
        infoDes = "Feels like: ";
      });
    }
    if (deger.first.weatherMain.toString() == "Rain") {
      setState(() {
        backgroundColor = CustomColors.rainBlue;
        finalArt = const Rain();
        info = deger.first.rainLastHour.toString();
        infoDes = "Rain volume: ";
      });
    }
    if (deger.first.weatherMain.toString() == "Snow") {
      setState(() {
        backgroundColor = CustomColors.rainBlue;
        finalArt = const Rain();
        info = deger.first.snowLastHour.toString();
        infoDes = "Snow volume: ";
      });
    }
    setState(() {
      adminArea = deger.first.areaName.toString();
      main = deger.first.weatherMain.toString();
      temp = deger.first.temperature.toString();
      des = deger.first.weatherDescription.toString();
    });
  }

  void reload2() {
    setState(() {
      adminArea = widget.cityname;
      temp = widget.temperature;
      hum = widget.humidity;
      wind = widget.windSpeed;
      des = widget.condition;
    });
  }

  /*void ad() async {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _ad = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('InterstitialAd failed to load: $error');
            }
          },
        ));
  }*/

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("My title"),
      content: const Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
