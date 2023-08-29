import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hwp_lib/flutter_hwp_lib.dart';
import 'package:flutter_hwp_lib/flutter_hwp_lib_platform_interface.dart';
import 'package:flutter_hwp_lib/flutter_hwp_lib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterHwpLibPlatform
    with MockPlatformInterfaceMixin
    implements FlutterHwpLibPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterHwpLibPlatform initialPlatform = FlutterHwpLibPlatform.instance;

  test('$MethodChannelFlutterHwpLib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterHwpLib>());
  });

  test('getPlatformVersion', () async {
    FlutterHwpLib flutterHwpLibPlugin = FlutterHwpLib();
    MockFlutterHwpLibPlatform fakePlatform = MockFlutterHwpLibPlatform();
    FlutterHwpLibPlatform.instance = fakePlatform;

    expect(await flutterHwpLibPlugin.getPlatformVersion(), '42');
  });
}
