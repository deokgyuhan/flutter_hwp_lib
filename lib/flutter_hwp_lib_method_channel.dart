import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_hwp_lib_platform_interface.dart';

/// An implementation of [FlutterHwpLibPlatform] that uses method channels.
class MethodChannelFlutterHwpLib extends FlutterHwpLibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_hwp_lib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
