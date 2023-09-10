package com.novice.flutter_hwp_lib

import android.annotation.SuppressLint
import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kr.dogfoot.hwplib.`object`.HWPFile
import kr.dogfoot.hwplib.reader.HWPReader
import kr.dogfoot.hwplib.tool.textextractor.TextExtractMethod
import kr.dogfoot.hwplib.tool.textextractor.TextExtractor
import kr.dogfoot.hwplib.tool.textextractor.TextExtractorListener
import java.io.File
import kotlin.io.print as print


/** FlutterHwpLibPlugin */
class FlutterHwpLibPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var activity: Activity? = null

  private lateinit var methodChannel : MethodChannel
  private var eventChannel: EventChannel? = null
    private var _flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

  private val methodChannelName = "flutter_hwp_lib/method"
  private val eventChannelName = "flutter_hwp_lib/event"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    _flutterPluginBinding = flutterPluginBinding
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    methodChannel.setMethodCallHandler(this)
  }

  @SuppressLint("SuspiciousIndentation")
  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if(call.method == "extractingText") {
      val filePath = call.argument<String>("filePath")
        if (filePath != null) {
            extractingText(filePath)
            result.success("success")
        }  else {
            result.success("failure")
        }

    }
  }

  private fun setupEventChannel() {
      print("--------------------->setupEventChannel")

        eventChannel = EventChannel(_flutterPluginBinding!!.binaryMessenger, eventChannelName)
        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, eventSink: EventChannel.EventSink) {

                val argsMap = p0 as? Map<String, Any>
                val filePath = argsMap?.get("filePath") as? String

                if (filePath != null) {
                    eventSink?.success("---------->" + filePath)
                    extractingTextFromBigFile(filePath, eventSink)
                }
            }

            override fun onCancel(p0: Any?) {}
        })
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null)
  }
//    private fun extractingTextFromBigFile(filePath: String) {
//        class MyListener : TextExtractorListener {
//            override fun paragraphText(text: String) {
//                print(text)
//            }
//        }
//
//        try {
//            HWPReader.forExtractText(filePath, MyListener(), TextExtractMethod.InsertControlTextBetweenParagraphText)
//        } catch (e: Exception) {
//            e.printStackTrace()
//        }
//    }
    private fun extractingTextFromBigFile(filePath: String, eventSink: EventChannel.EventSink) {
        class MyListener : TextExtractorListener {
            override fun paragraphText(text: String) {
                eventSink?.success(text)
            }
        }

        try {
            HWPReader.forExtractText(filePath, MyListener(), TextExtractMethod.InsertControlTextBetweenParagraphText)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
  private fun extractingText(filePath: String) {
      val hwpFile: HWPFile
      val hwpText: String
      try {
          hwpFile = HWPReader.fromFile(filePath)
          hwpText = TextExtractor.extract(
              hwpFile,
              TextExtractMethod.InsertControlTextBetweenParagraphText
          )

          println("===== hwp text extractor =====")

          // 문자열을 개행 문자로 분할하여 배열 생성
          val lines = hwpText.split("\n")

          // 빈 공백이 아닌 값만 포함된 새로운 배열 생성
          val nonEmptyLines = lines.filter { it.isNotBlank() }

          println("hwpText = $nonEmptyLines")
      } catch (e: Exception) {
          e.printStackTrace()
      }
  }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        setupEventChannel()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        eventChannel = null
        _flutterPluginBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
        eventChannel = null
        _flutterPluginBinding = null
    }
}
