import Flutter
import UIKit
import CoreHwp

public class FlutterHwpLibPlugin: NSObject, FlutterPlugin {
  var temp: HwpFile

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_hwp_lib", binaryMessenger: registrar.messenger())
    let instance = FlutterHwpLibPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
