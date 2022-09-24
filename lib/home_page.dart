// ignore_for_file: prefer_const_constructors, argument_type_not_assignable_to_error_handler

import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv/connected.dart';
import 'package:flutter_tv/not_connected.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;
  final keyController = TextEditingController();
  var isDeviceConnected = false;
  static var box = Hive.box("MyBaza");
  String urlKey = "";
  String url = "213.139.209.162";
  bool isChange = false;
  bool isChangeSocket = false;

  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (isDeviceConnected) {
          isChange = true;
          hive();
        } else {
          isChange = false;
          setState(() {});
        }
      });

  webSocket() {
    var channel = IOWebSocketChannel.connect(
        Uri.parse("ws://$url:8000/app/ws/stream/$urlKey"));
    channel.stream.listen(
      (message) {
        if (message == "reload") {
          isChangeSocket = true;
          setState(() {});
          reload();
        }
        if (message == "delete_key") {
          box.put("key", null);
          hive();
        }
      },
      onError: (error) {
        keyController.text = "";
        box.put("key", null);
        hive();
      },
    );
  }

  reload() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      isChangeSocket = false;
      setState(() {});
      timer.cancel();
    });
  }

  hive() async {
    var keyjson = await box.get("key");
    if (keyjson != null) {
      urlKey = keyjson;
      webSocket();
    } else {
      _showMyDialog();
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isChange
          ? isChangeSocket
              ? view()
              : Connected(
                  url: url,
                  urlKey: urlKey,
                )
          : NotConnected(),
    );
  }

  Widget view() {
    return Stack(
      children: [
        Container(
          color: Colors.green,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    "ISHONCH",
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 47),
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        "ISHONCH",
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 45),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: const Duration(milliseconds: 500),
                    displayFullTextOnTap: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sizda hali maxfiy kod kiritilmagan'),
          content: Container(
            height: 55,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: Colors.green, width: 1, style: BorderStyle.solid)),
            child: TextField(
              controller: keyController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Saqlash',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (keyController.text.isNotEmpty) {
                  box.put("key", keyController.text.trim());
                  hive();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
