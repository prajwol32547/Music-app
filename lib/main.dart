// import 'dart:html';
import 'package:app/favorite.dart';
import 'package:app/search.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import './body.dart';

void main() {
  runApp(MaterialApp(
    title: 'Music',
    home: home(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatelessWidget {
  void requestPermission() {
    Permission.storage.request();
  }

  Widget build(BuildContext context) {
    requestPermission();

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
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchScreen();
                  }));
                },
                icon: Icon(Icons.search)),
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
