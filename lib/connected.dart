// ignore_for_file: unrelated_type_equality_checks, sized_box_for_whitespace, prefer_const_constructors
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class Connected extends StatefulWidget {
  const Connected({
    Key? key,
    required this.url,
    required this.urlKey,
  }) : super(key: key);

  final String url;
  final String urlKey;
  @override
  State<Connected> createState() => _ConnectedState();
}

class _ConnectedState extends State<Connected> {
  late VlcPlayerController videoPlayerController;
  bool error = true;
  @override
  void initState() {
    super.initState();
    videoStream();
  }

  videoStream() async {
    String urlStream = 'http://${widget.url}//live/${widget.urlKey}/index.m3u8';
    videoPlayerController = VlcPlayerController.network(
      urlStream,
      hwAcc: HwAcc.FULL,
      options: VlcPlayerOptions(),
    );
    error = false;
    setState(() {});
    test();
  }

  test() {
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.playingState == PlayingState.ended ||
          videoPlayerController.value.playingState == PlayingState.error) {
        error = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: error
          ? Stack(
              children: [
                Container(
                    color: Colors.green,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AnimatedTextKit(
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
                    )),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                        alignment: Alignment.center,
                        child: AnimatedTextKit(
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
                          pause: Duration(milliseconds: 500),
                          displayFullTextOnTap: true,
                        )),
                  ),
                )
              ],
            )
          : Container(
              height: size.height,
              width: size.width,
              child: VlcPlayer(
                controller: videoPlayerController,
                aspectRatio: videoPlayerController.value.aspectRatio,
                placeholder: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}
