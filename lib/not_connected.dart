// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NotConnected extends StatefulWidget {
  const NotConnected({Key? key}) : super(key: key);

  @override
  State<NotConnected> createState() => _NotConnectedState();
}

class _NotConnectedState extends State<NotConnected> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset("assets/video1.mp4")
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: controller != null
          ? Container(
              height: size.height,
              width: size.width,
              child: VideoPlayer(controller),
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
