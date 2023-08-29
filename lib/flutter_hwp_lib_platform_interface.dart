import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_hwp_lib_method_channel.dart';

abstract class FlutterHwpLibPlatform extends PlatformInterface {
  /// Constructs a FlutterHwpLibPlatform.
  FlutterHwpLibPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterHwpLibPlatform _instance = MethodChannelFlutterHwpLib();

  /// The default instance of [FlutterHwpLibPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterHwpLib].
  static FlutterHwpLibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterHwpLibPlatform] when
  /// they register themselves.
  static set instance(FlutterHwpLibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
