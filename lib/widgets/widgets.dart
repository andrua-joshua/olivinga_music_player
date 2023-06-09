import 'package:flutter/material.dart';
import 'package:learningdart/providers_and_notifiers/favourite_change_notifier.dart';
import 'package:learningdart/providers_and_notifiers/floating_player_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:learningdart/routes.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:learningdart/routes/start_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../providers_and_notifiers/audio_strams_combiner.dart';

///
///This is where all the widgets of the application will be created
///
//ignore: camel_case_types
class bottomStartWidget extends StatelessWidget {
  const bottomStartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      //decoration: const BoxDecoration(color: Color.fromARGB(221, 66, 61, 61)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Playme.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "We're the second most popular place to listen to " +
                "music in the world - and growing fast",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.left,
          ),
          Text(
            "...",
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

///
///this class is the one to hold and manage the custom tabs
/// for holding the favourite , playlist and tracks
///
//ignore: camel_case_types
class homeTabs extends StatelessWidget {
  const homeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Playlists",
                style: TextStyle(color: Colors.white, fontSize: 17),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                "Tracks",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                "Favourites",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
        ],
      ),
    );
  }
}

///
///this is the oneto display all the tracks on the device
///
//ignore: camel_case_types
class tracksWidget extends StatefulWidget {
  final bool favourite;
  const tracksWidget({this.favourite = false, Key? key}) : super(key: key);

  @override
  tracksWidgetState createState() => tracksWidgetState();
}

//ignore: camel_case_types
class tracksWidgetState extends State<tracksWidget> {
  final OnAudioQuery _audioQuery = staticData.audioQuery;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    //check and request for media access permissions
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermissions = await _audioQuery.checkAndRequest(retryRequest: retry);

    //only call update the UI if have all the required permissions
    _hasPermissions ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<favouriteChangeNotifier>(
        create: (_) => favouriteChangeNotifier(),
        child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 24, 23, 23)),
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            child: Consumer<favouriteChangeNotifier>(
              builder: (_, value, cild) {
                return ListView.builder(
                    itemCount: staticData.isFavourites
                        ? staticData.favouriteTracksPlaylist.length + 1
                        :
                         staticData.allTracksPlaylist.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return upperWidget(widget.favourite
                            ? "Favourite tracks"
                            : "All tracks");
                      }

                      return trackWidget(
                        favourite: widget.favourite,
                        index: index - 1,
                        isplaylist: floatingPlayerNotifier().started,
                      );
                    });
              },
            )));
  }
}

///
///The music icon listed with the tracks
///
//ignore: camel_case_types
class trackIcon extends StatelessWidget {
  const trackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 70, 67, 67)),
      padding: const EdgeInsets.all(10),
      child: const Icon(
        Icons.music_note,
        color: Colors.white,
      ),
    );
  }
}

///
///the widget that holds the track
///
//ignore: camel_case_types
class trackWidget extends StatelessWidget {
  final bool favourite;
  final bool isplaylist;
  final int index;
  const trackWidget(
      {this.isplaylist = false,
      required this.favourite,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouriteTracksPlaylist = staticData.favouriteTracksPlaylist;
    final allTracksPlaylist = staticData.allTracksPlaylist;
    final favouriteSongModelMapping = staticData.favouriteSongModelMapping;
    final allTrackSongModelMapping = staticData.allTrackSongModelMapping;
    return ListTile(
      onTap: () {
        
        staticData.player.setAudioSource(
            favourite ? favouriteTracksPlaylist : allTracksPlaylist,
            initialIndex: index);
        staticData.isFavourites = favourite ? true : false;
        floatingPlayerNotifier().setStarted(true);
        isplaylist
            ? null
            : Navigator.pushNamed(context, RouteGenerator.playerscreen);
      },
      leading: const trackIcon(),
      title: StreamBuilder(
        stream: staticData.player.currentIndexStream,
        builder: (context, snapShot) {
          return Text(
            favourite
                ? favouriteSongModelMapping[index]?.title ?? ""
                : allTrackSongModelMapping[index]?.title ?? "",
            style: TextStyle(
                color: isCurrentPlaying(index) ? Colors.blue : Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      subtitle: subDividerWidget(
          artist: favourite
              ? staticData.favouriteSongModelMapping[index]?.artist ?? "unknown"
              : staticData.allTrackSongModelMapping[index]?.artist ??
                  "unknown"),
      trailing: const Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
    );
  }

  bool isCurrentPlaying(int index) {
    bool val = false;
    val = staticData.player.currentIndex == index;
    return val;
  }
}

///
///the track subtitle
///
//ignore: camel_case_types
class subDividerWidget extends StatelessWidget {
  final String artist;
  const subDividerWidget({required this.artist, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artist,
            style: const TextStyle(color: Colors.grey),
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}

///
///The upper hand in the tracks
///
//ignore: camel_case_types
class upperWidget extends StatelessWidget {
  final String title;
  const upperWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () {
                    staticData.player.setAudioSource(
                        staticData.isFavourites
                            ? staticData.favouriteTracksPlaylist
                            : staticData.allTracksPlaylist,
                        initialIndex: 0);
                    staticData.player.play();
                    floatingPlayerNotifier().setStarted(true);
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}

///
///This widget is responsible for showing the playlists
///
//ignore: camel_case_types
class playlistsWidget extends StatelessWidget {
  const playlistsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 24, 23, 23)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(5, 13, 5, 5),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 17,
            mainAxisExtent: 170),
        children: List.generate(7, (index) => playlistWidget(index: index)),
      ),
    );
  }
}

///
///This is for reprenting the playlists
///
//ignore: camel_case_types
class playlistWidget extends StatelessWidget {
  final int index;
  const playlistWidget({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
              child: Card(
            elevation: 5,
            color: Color.fromARGB(137, 77, 76, 76),
            child: Center(
                child: Icon(
              Icons.music_note_outlined,
              color: Colors.white,
              size: 40,
            )),
          )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Playlist $index",
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

///
///playing track controls
///
//ignore: camel_case_types
class playingTrackControls extends StatelessWidget {
  const playingTrackControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shuffle,
              color: Colors.grey,
            )),
        IconButton(
            onPressed: () {
              staticData.player.seekToPrevious();
            },
            icon: const Icon(
              Icons.skip_previous_outlined,
              color: Colors.white,
            )),
        Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 44, 245, 235),
                Color.fromARGB(255, 88, 243, 235),
                Color.fromARGB(255, 165, 248, 244)
              ])),
          padding: const EdgeInsets.all(7),
          child: StreamBuilder<PlayerState>(
            stream: staticData.player.playerStateStream,
            builder: ((context, snapshot) {
              if (!snapshot.data!.playing) {
                return IconButton(
                  onPressed: () {
                    staticData.player.play();
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                  ),
                );
              }

              return IconButton(
                onPressed: () {
                  staticData.player.pause();
                },
                icon: const Icon(
                  Icons.pause,
                  color: Colors.black,
                ),
              );
            }),
          ),
        ),
        IconButton(
            onPressed: () {
              staticData.player.seekToNext();
            },
            icon: const Icon(
              Icons.skip_next_outlined,
              color: Colors.white,
            )),
        StreamBuilder(
            stream: staticData.player.loopModeStream,
            builder: (context, loop) {
              if (loop.hasData) {
                return IconButton(
                    onPressed: () {
                      (loop.data == LoopMode.off)
                          ? staticData.player.setLoopMode(LoopMode.all)
                          : (loop.data == LoopMode.all)
                              ? staticData.player.setLoopMode(LoopMode.one)
                              : staticData.player.setLoopMode(LoopMode.off);
                    },
                    icon: Icon(
                        (loop.data == LoopMode.off)
                            ? Icons.repeat_outlined
                            : (loop.data == LoopMode.all)
                                ? Icons.repeat_on
                                : Icons.repeat_one_on,
                        color: Colors.grey));
              }
              if (loop.hasError) {
                return const Text(
                  "Error",
                  style: TextStyle(color: Colors.red),
                );
              }
              return const CircularProgressIndicator();
            })
      ],
    );
  }
}

///
///This is to hold the title of the music
///
//ignore: camel_case_types
class trackTitleWidget extends StatelessWidget {
  const trackTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return StreamBuilder(
          stream: staticData.player.currentIndexStream,
          builder: (context, snapshot) {
            return SizedBox(
                width: size.maxWidth,
                child: ChangeNotifierProvider<favouriteChangeNotifier>(
                    create: (context) => favouriteChangeNotifier(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          staticData.isFavourites
                              ? staticData
                                      .favouriteSongModelMapping[
                                          staticData.player.currentIndex]
                                      ?.title ??
                                  "unknown"
                              : staticData
                                      .allTrackSongModelMapping[
                                          staticData.player.currentIndex]
                                      ?.title ??
                                  "unknown",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Consumer<favouriteChangeNotifier>(
                            builder: (context, value, child) {
                          return IconButton(
                              onPressed: () {
                                if (!staticData.isFavourites) {
                                  value.checkAndAddFavourite(
                                      staticData.allTrackSongModelMapping[
                                              staticData.player.currentIndex] ??
                                          SongModel({}));
                                } else {
                                  value.checkAndRemoveFavourite(
                                      staticData.player.currentIndex ?? 555);
                                }
                              },
                              icon: Icon(
                                staticData.isFavourites
                                    ? Icons.favorite_outlined
                                    : favouriteChangeNotifier().isFavourite(
                                            staticData.allTrackSongModelMapping[
                                                    staticData
                                                        .player.currentIndex] ??
                                                SongModel({}))
                                        ? Icons.favorite_outlined
                                        : Icons.favorite_outline,
                                color: const Color.fromARGB(255, 88, 243, 235),
                                size: 30,
                              ));
                        })
                      ],
                    )));
          });
    });
  }
}

///
///this is for tracking of the playing tracks tym
///
//ignore: camel_case_types
class durationsWidget extends StatelessWidget {
  final Stream<PositionData> stream;
  const durationsWidget(this.stream, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
        stream: stream,
        builder: (context, positiondata) {
          if (positiondata.hasError) {
            return const Text("Error");
          }

          if (positiondata.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(positiondata.data?.position ?? Duration.zero),
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(formatTime(positiondata.data?.duration ?? Duration.zero),
                    style: const TextStyle(color: Colors.grey))
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }

  String formatTime(Duration duration) {
    String time = "00";

    int secs = duration.inSeconds % 60;
    int mins = ((duration.inSeconds - secs) / 60).round();
    double hours = (duration.inSeconds - (60 * mins)) / 60;
    int hrs = hours.round();

    time = "$mins:$secs";
    return time;
  }
}

///
///the whole track plays
///
//ignore: camel_case_types
class trackDetailsWidget extends StatelessWidget {
  const trackDetailsWidget({super.key});

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          staticData.player.positionStream,
          staticData.player.bufferedPositionStream,
          staticData.player.durationStream,
          (position, bufferedDuration, duration) => PositionData(
              position, bufferedDuration, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const trackTitleWidget(),
        const Text(
          "unknown",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 15,
        ),
        StreamBuilder(
            stream: _positionDataStream,
            builder: (context, positiondata) {
              int currentPosition = positiondata.data?.position.inSeconds ?? 0;
              int duration = positiondata.data?.duration.inSeconds ?? 0;
              if (positiondata.hasError) {
                return const Text(
                  "there was an error",
                  style: TextStyle(color: Colors.red),
                );
              }
              if (positiondata.hasData) {
                if (positiondata.data == null) {
                  return const CircularProgressIndicator();
                }
                return Slider(
                  activeColor: const Color.fromARGB(255, 88, 243, 235),
                  inactiveColor: Colors.grey,
                  value: currentPosition / duration,
                  onChanged: (val) async {
                    double nVal = duration * val;
                    await staticData.player
                        .seek(Duration(seconds: nVal as int));
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        durationsWidget(_positionDataStream),
        const SizedBox(
          height: 10,
        ),
        const playingTrackControls()
      ],
    );
  }
}

///
///The widget for the floating action to represent the playing music
///
//ignore: camel_case_types
class floatingPlayer extends StatelessWidget {
  const floatingPlayer({super.key});

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          staticData.player.positionStream,
          staticData.player.bufferedPositionStream,
          staticData.player.durationStream,
          (position, bufferedDuration, duration) => PositionData(
              position, bufferedDuration, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 95, 211, 247)),
      child: Column(
        children: [
          const floatPlayerControls(),
          Container(
              child: StreamBuilder(
                  stream: _positionDataStream,
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      final int val1 = snapShot.data?.position.inSeconds ?? 0;
                      final int val2 = snapShot.data?.duration.inSeconds ?? 1;
                      final double val = val1 / val2;
                      return LinearProgressIndicator(
                        value: val,
                      );
                    }
                    return const LinearProgressIndicator();
                  }))
        ],
      ),
    );
  }
}

///
///the play Controls
///
//ignore: camel_case_types
class floatPlayerControls extends StatelessWidget {
  const floatPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: staticData.player.currentIndexStream,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  if (snapShot.hasData) {
                    return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.playerscreen),
                        child: Text(
                          staticData.isFavourites
                              ? staticData
                                      .favouriteSongModelMapping[snapShot.data]
                                      ?.title ??
                                  "unknown"
                              : staticData
                                      .allTrackSongModelMapping[snapShot.data]
                                      ?.title ??
                                  "unknown",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ));
                  }

                  return const CircularProgressIndicator();
                })),
        IconButton(
            onPressed: () {
              staticData.player.seekToPrevious();
            },
            icon: const Icon(Icons.skip_previous_outlined)),
        StreamBuilder(
            stream: staticData.player.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Error",
                  style: TextStyle(color: Colors.red),
                );
              }
              if (snapshot.hasData) {
                return IconButton(
                    onPressed: () {
                      staticData.player.playing
                          ? staticData.player.pause()
                          : staticData.player.play();
                    },
                    icon: Icon(
                      staticData.player.playing
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined,
                      color: Colors.white,
                    ));
              }
              return const CircularProgressIndicator();
            }),
        IconButton(
            onPressed: () {
              staticData.player.seekToNext();
            },
            icon: const Icon(Icons.skip_next_outlined)),
      ],
    );
  }
}
