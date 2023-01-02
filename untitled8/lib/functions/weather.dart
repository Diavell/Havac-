import 'package:weather/weather.dart';

import 'location.dart';

class WeatherPage {
  String? country, adminArea;
  List<Weather> data = [];
  late WeatherFactory wf;

  Future<List<Weather>> getWeather() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      country = placeMark?.country ?? 'could not get country';
      adminArea = placeMark?.administrativeArea ?? 'could not get admin area';
    }
    wf = WeatherFactory("eefd4c0e4119d1ba50c49d9acf649059",
        language: Language.ENGLISH);
    Weather weather = (await wf.currentWeatherByCityName(adminArea!));
    data = [weather];
    return data;
  }
}
