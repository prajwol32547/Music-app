import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print(index);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                  child: ListTile(
                      leading: Icon(Icons.music_note_outlined),
                      title: Text('favourites ${index + 1}'),
                      trailing: Icon(Icons.play_circle_fill_outlined)),
                ),
              );
            },
          ),
        ),
      ),
    ]));
  }
}
