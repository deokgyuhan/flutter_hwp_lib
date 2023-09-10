import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_hwp_lib/flutter_hwp_lib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterHwpLibPlugin = FlutterHwpLib();

  List<String> _events = [];
  final _eventStreamController = StreamController<String>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _eventStreamController.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterHwpLibPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
              'flutter_hwp_lib example',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
        ),
        body:  Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10,),
            child: Column(
              children: [
                // Center(
                //   child: Text('Running on: $_platformVersion\n'),
                // ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MethodChannel Call',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String? filePath = "";
                              String full_path = "";

                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                filePath =  result.files.single.path;
                                full_path = filePath.toString();
                                if(filePath != null) {
                                  print("----------------->filePath: " + filePath);
                                  print("----------------->fullPath: " + full_path);
                                  await _extractingText(filePath);
                                }

                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Text("Select file"),
                          ),
                        ]),
                  ],
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EventChannel Call',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String? filePath = "";
                              String full_path = "";

                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                filePath =  result.files.single.path;
                                full_path = filePath.toString();
                                if(filePath != null) {
                                  print("----------------->filePath: " + filePath);
                                  print("----------------->fullPath: " + full_path);

                                  _extractingTextFromBigFile(filePath);
                                }
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Text("Select file"),
                          ),
                        ]),
                    SizedBox(height: 10,),

                    Container(
                      child: Container(
                        width: double.infinity,
                        // height: double.infinity,
                        height:  MediaQuery.of(context).size.height*0.6,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child:
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(
                                  _events[index],
                                  style: TextStyle(fontSize: 15,),
                                )
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _extractingText(String filePath) async {
    _clearLog();
    _eventStreamController.sink.add('MethodChannel Call...');

    var text = await _flutterHwpLibPlugin.extractingText(filePath);
    _eventStreamController.sink.add('-> '+text!);
    _addEvent('MethodChannel Call...');
    _addEvent(text);
  }

  StreamSubscription<dynamic>? _eventSubscription;
  void _extractingTextFromBigFile(String filePath) async {

    _clearLog();
    _eventStreamController.sink.add('EventChannel Call...');

    _addEvent('EventChannel Call...');
    _eventSubscription =  await _flutterHwpLibPlugin
        .extractingTextFromBigFile(filePath)
        .listen((event) {
          _eventStreamController.sink.add('-> '+event);
          _addEvent(event);
      print('----------------------->event: ' + event);
    });
  }

  void _clearLog() {
    setState(() {
      _events.clear();
    });
  }

  void _addEvent(String event)  {
    setState(() {
      _events.add(event);
    });

    // Scroll to the end of the list
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
