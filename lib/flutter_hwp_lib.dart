
import 'flutter_hwp_lib_platform_interface.dart';

class FlutterHwpLib {
  Future<String?> getPlatformVersion() {
    return FlutterHwpLibPlatform.instance.getPlatformVersion();
  }
}
