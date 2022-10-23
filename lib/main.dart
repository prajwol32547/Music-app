// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import './body.dart';
import './body2.dart';

void main() {
  runApp(MaterialApp(
    title: 'Music',
    home: home(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 100,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              'Music',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          actions: [
            Icon(Icons.search),
            Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_horiz_outlined))
          ]),
      body: PageView(
        children: [Body(), Favourite()],
        pageSnapping: true,
      ),
    );
  }
}
