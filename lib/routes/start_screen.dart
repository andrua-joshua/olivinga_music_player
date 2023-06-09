import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:learningdart/routes.dart';
import 'package:learningdart/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

///
///This will be the one shown on the first opening of the app
///
///
//ignore: camel_case_types
class startScreen extends StatefulWidget {
  const startScreen({super.key});

  @override
  startScreenState createState() => startScreenState();
}

//ignore:camel_case_types
class startScreenState extends State<startScreen> {
  final _player = staticData.player;
  final OnAudioQuery _audioQuery = staticData.audioQuery;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    //check and request for media access permissions
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = true}) async {
    _hasPermissions = await _audioQuery.checkAndRequest(retryRequest: retry);

    //only call update the UI if have all the required permissions
    //_hasPermissions ? setState(() {}) : null;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, size) {
          Future.delayed(const Duration(seconds: 2), () async {
            await _audioQuery
                .querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true)
                .then((value) {
              staticData.allTracksPlaylist.clear();
              staticData.allTrackSongModelMapping.clear();
              staticData.favouriteSongModelMapping.clear();
              staticData.favouriteTracksPlaylist.clear();

              for (int index = 0; index < value.length; index++) {
                //adding the tracks to the allTracksPlaylist
                staticData.allTracksPlaylist
                    .add(AudioSource.uri(Uri.parse(value[index].uri ?? "")));

                //adding the songModel to the mapped allTracksSongModel
                staticData.allTrackSongModelMapping
                    .putIfAbsent(index, () => value[index]);
              }

              staticData.favouriteSongModelMapping.clear();
              staticData.favouriteTracksPlaylist.clear();

              //this is for debugging
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: Text(
              //           "size = ${value.length} and all: ${staticData.allTracksPlaylist.length}, favourite: ${staticData.favouriteTracksPlaylist.length}",
              //           style: const TextStyle(color: Colors.white),
              //         ),
              //       );
              //     });

              while (!_hasPermissions);
              
              Navigator.pushNamed(context, RouteGenerator.homescreen);
            });
          });
          return SafeArea(
              child: Container(
                  alignment: Alignment.bottomLeft,
                  constraints: const BoxConstraints.expand(),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: Image.asset("assets/images/bg.jpg")),
                      const bottomStartWidget()
                    ],
                  )));
        },
      ),
    );
  }
}
