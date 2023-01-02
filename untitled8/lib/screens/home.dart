import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:untitled8/screens/all.dart';
import 'package:untitled8/screens/rainy.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: controller,
      items: const [
        //SunnyPage(),
        //CloudyPage(),
        RainyPage()
      ],
      options: CarouselOptions(
          viewportFraction: 1,
          height: double.infinity,
          enableInfiniteScroll: false),
    );
  }
}
