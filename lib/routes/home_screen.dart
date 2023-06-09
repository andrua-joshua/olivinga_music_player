import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:learningdart/providers_and_notifiers/floating_player_notifier.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:learningdart/widgets/widgets.dart';
import 'package:provider/provider.dart';

///
///This is responsible for showing the playlist, favourites and trackd
///
///
//ignore: camel_case_types
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  homeScreenState createState() => homeScreenState();
}

//ignore: camel_case_types
class homeScreenState extends State<homeScreen> {
  final _player = staticData.player;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    _init();
  }

  @override
  void dispose() {


    super.dispose();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      //print("A stream error ocurred: $e");
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: const Text(
              "Olivinga music",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
            //flexibleSpace: ,
            bottom: const TabBar(
                dividerColor: Colors.black,
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                unselectedLabelStyle:
                    TextStyle(color: Colors.grey, fontSize: 15),
                indicatorWeight: 0.1,
                indicatorColor: Colors.black,
                tabs: [
                  // Text(
                  //   "Playlists",
                  // ),
                  Text(
                    "Tracks",
                  ),
                  Text(
                    "Favourites",
                  )
                ]),
          ),
          body: const SafeArea(
            child: TabBarView(
              children: [
                //playlistsWidget(),
                tracksWidget(),
                tracksWidget(
                  favourite: true,
                )
              ],
            ),
          ),
          floatingActionButton: ChangeNotifierProvider(
            create: (context) => floatingPlayerNotifier(),
            child: Container(
              child: Consumer<floatingPlayerNotifier>(
                builder: (context, value, child) {
                  return value.started ? const floatingPlayer() : Container();
                },
              ),
            ),
          ),
        ));
  }
}
