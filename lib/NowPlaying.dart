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
  bool _isPlaying = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    playNow();

    // Listen to the position stream and update the slider value
    widget.audioplayer.positionStream.listen((Duration position) {
      setState(() {
        // Calculate the percentage of audio played
        _sliderValue = position.inMilliseconds / widget.songModel.duration!;
      });
    });
  }

  void playNow() {
    try {
      widget.audioplayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioplayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      log('Error playing song: $e');
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
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(_sliderValue.clamp(0.0, 1.0).toStringAsFixed(2)),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max:
                                1.0, // Use 1.0 as the maximum value for the slider
                            value: _sliderValue.clamp(0.0, 1.0),
                            onChanged: (value) {
                              _sliderValue = value;
                              // Handle slider value change (optional)
                            },
                            onChangeEnd: (value) {
                              // Seek to the position when the user stops dragging the slider
                              final newPosition =
                                  (value * widget.songModel.duration!).toInt();
                              widget.audioplayer
                                  .seek(Duration(milliseconds: newPosition));
                            },
                            thumbColor: Colors.black,
                            activeColor: Colors.black45,
                            inactiveColor: Colors.white,
                          ),
                        ),
                        Text((widget.songModel.duration! / 60000)
                            .toStringAsFixed(2)),
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
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                            if (_isPlaying) {
                              widget.audioplayer.play();
                            } else {
                              widget.audioplayer.pause();
                            }
                          });
                        },
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled_outlined
                              : Icons.play_circle_fill_outlined,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_next_outlined,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void dispose() {
  //   widget.audioplayer.dispose();
  //   super.dispose();
  // }
}
