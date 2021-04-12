
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLeakFind {
  static const MethodChannel _channel =
      const MethodChannel('flutter_leak_find');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
