
import 'flutter_hwp_lib_platform_interface.dart';

class FlutterHwpLib {
  Future<String?> getPlatformVersion() {
    return FlutterHwpLibPlatform.instance.getPlatformVersion();
  }

  Future<String?> extractingText(String filePath) {
    return FlutterHwpLibPlatform.instance.extractingText(filePath);
  }

  Stream<dynamic> extractingTextFromBigFile(String filePath)  {
    return FlutterHwpLibPlatform.instance.extractingTextFromBigFile(filePath);
  }
}
