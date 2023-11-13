import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class Song {
  final String songTitle;

  Song(this.songTitle);
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _audioquery = new OnAudioQuery();

  bool result = false;
  List<String> queryList = [];
  List<SongModel> allList = [];

  List<SongModel> searchList = [];

  void initState() {
    super.initState();
    loadSong();
  }

  void loadSong() async {
    // Load all songs initially
    allList = await _audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  Future<void> _handleSearch(BuildContext context, String query) async {
    print("Searching for: $query");
    queryList.add(query);

    // Filter songs based on the search query
    searchList = allList
        .where((song) =>
            song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (!searchList.isEmpty) {
      setState(() {
        result = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (query) {},
                onSubmitted: (query) {
                  _handleSearch(context, query);
                },
                decoration: InputDecoration(
                  hintText: 'Search on Music',
                  prefixIcon: Icon(Icons.more_horiz),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final query = _searchController.text;
                _handleSearch(context, query);
              },
            ),
          ],
        ),
        body: result == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      mainAxisSpacing: 8.0, // Spacing between rows
                      crossAxisSpacing: 8.0, // Spacing between columns
                      childAspectRatio: 1.0, // Aspect ratio of each grid item
                    ),
                    itemCount: searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridTile(
                        child: Container(
                          height: 400,
                          width: 180,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              searchList[index].displayName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: queryList == null
                    ? Center(child: Text("No search queries"))
                    : ListView.builder(
                        itemCount: queryList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.search),
                            title: Text(queryList![index]),
                            trailing: Icon(Icons.link_rounded),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
