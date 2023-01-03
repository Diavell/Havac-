import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7788254293883124/6479977041";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7788254293883124~7601487027";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
