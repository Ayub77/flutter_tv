import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tv/home_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NotVideo extends StatefulWidget {
  const NotVideo({Key? key, required this.channel, required this.videoName})
      : super(key: key);
  final WebSocketChannel channel;
  final String videoName;

  @override
  State<NotVideo> createState() => _NotVideoState();
}

class _NotVideoState extends State<NotVideo> {
  VideoPlayerController? controller;
  static var box = Hive.box("MyBaza");

  WEBSocket() {
    widget.channel.stream.listen((message) {
      if (message == "reload") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
        widget.channel.sink.close();
      }
      if (message == "delete_key") {
        box.put("key", null);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WEBSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Colors.green,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            "ISHONCH",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 45),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "ISHONCH",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 40),
                )),
          ),
        )
      ],
    ));
  }
}
