import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_hwp_lib_platform_interface.dart';

/// An implementation of [FlutterHwpLibPlatform] that uses method channels.
class MethodChannelFlutterHwpLib extends FlutterHwpLibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_hwp_lib/method');

  @visibleForTesting
  final eventChannel = const EventChannel('flutter_hwp_lib/event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> extractingText(String filePath) async {
    final result = await methodChannel.invokeMethod<String>('extractingText', <String, dynamic>{'filePath': filePath});
    return result;
  }

  @override
  Stream<dynamic> extractingTextFromBigFile(String filePath)  {
    return eventChannel.receiveBroadcastStream(<String, dynamic>{'filePath': filePath});
  }
}
