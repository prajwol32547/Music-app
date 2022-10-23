import 'package:app/NowPlaying.dart';
import 'package:flutter/Material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:permission_handler/permission_handler.dart';

class Body extends StatefulWidget {
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  // }

  // void requestPermission() {
  //   Permission.storage.request();
  // }

  final _audioquery = new OnAudioQuery();
  final AudioPlayer _audioPlayer = new AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: FutureBuilder<List<SongModel>>(
            future: _audioquery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true),
            builder: (context, item) {
              if (item.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (item.data!.isEmpty) {
                return Center(
                  child: Text("No songs found"),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: item.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NowPlaying(
                                      songModel: item.data![index],
                                      audioplayer: _audioPlayer,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                        child: ListTile(
                            leading: Icon(Icons.music_note_outlined),
                            title: Text(item.data![index].displayNameWOExt),
                            subtitle: Text('${item.data![index].artist}'),
                            trailing: Icon(Icons.play_circle_fill_outlined)),
                      ));
                },
              );
            },
          ),
        ),
      ),
    ]));
  }
}
