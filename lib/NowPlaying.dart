import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  NowPlaying({required this.songModel, required this.audioplayer});
  final SongModel songModel;
  final AudioPlayer audioplayer;
  @override
  NowState createState() => NowState();
}

class NowState extends State<NowPlaying> {
  bool _isplaying = false;

  @override
  void init() {
    super.initState();
    playNow();
  }

  void playNow() {
    try {
      widget.audioplayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioplayer.play();
      _isplaying = true;
    } on Exception {
      log('cannot play songs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(
                      Icons.music_note,
                      size: 80.0,
                    ),
                    radius: 100.0,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.songModel.displayNameWOExt,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: Text(
                      widget.songModel.artist.toString() == "<unknown>"
                          ? "Prajwol"
                          : widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("0.00"),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: 5,
                              value: 0.7,
                              onChanged: (value) {},
                              thumbColor: Colors.white,
                              activeColor: Colors.red,
                              inactiveColor: Colors.blue,
                            ),
                          ),
                          Text("5.00")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_previous_outlined,
                                size: 40,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _isplaying = !_isplaying;
                                  if (_isplaying) {
                                    widget.audioplayer.play();
                                  } else {
                                    widget.audioplayer.pause();
                                  }
                                });
                              },
                              icon: Icon(
                                _isplaying == true
                                    ? Icons.pause_circle_filled_outlined
                                    : Icons.play_circle_fill_outlined,
                                size: 40,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_next_outlined,
                                size: 40,
                              ))
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
