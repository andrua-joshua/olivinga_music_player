import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:on_audio_query/on_audio_query.dart';

///
///for handling all the changes in the alltracks playlist
///
//ignore: camel_case_types
class allTracksNotifier with ChangeNotifier {
  void checkAndAddToAllTracks(SongModel song) {
    final alltrackSongModel = staticData.allTrackSongModelMapping;
    final alltracksPlaylist = staticData.allTracksPlaylist;

    bool isPresent = false;
    alltrackSongModel.forEach((key, value) {
      isPresent = (value.title == song.title) ? true : false;
    });
    if (!isPresent) {
      int index = staticData.allTrackSongModelMapping.length;
      staticData.allTrackSongModelMapping.putIfAbsent(index, () => song);
      staticData.allTracksPlaylist
          .add(AudioSource.uri(Uri.parse(song.uri ?? "")));
    }
    notifyListeners();
  }

  void cleanAndAdd(List<SongModel> songs) {
    staticData.allTrackSongModelMapping.clear();
    for (int x = 0; x < songs.length; x++) {
      staticData.allTrackSongModelMapping.putIfAbsent(x, () => songs[x]);
    }

    notifyListeners();
  }
}
