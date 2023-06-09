import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:on_audio_query/on_audio_query.dart';

///
///This will be for notifing all the listeners about the change in the
///favourite playlist
///
//ignore: camel_case_types
class favouriteChangeNotifier with ChangeNotifier {
  favouriteChangeNotifier._();
  static final favouriteChangeNotifier _singleOb = favouriteChangeNotifier._();
  factory favouriteChangeNotifier() => _singleOb;

  void checkAndAddFavourite(SongModel song) {
    bool isPresent = false;
    staticData.favouriteSongModelMapping.forEach((key, value) {
      isPresent = (value.title == song.title) ? true : false;
    });

    if (!isPresent) {
      int index = staticData.favouriteSongModelMapping.length;
      staticData.favouriteSongModelMapping.putIfAbsent(index, () => song);
      staticData.favouriteTracksPlaylist
          .add(AudioSource.uri(Uri.parse(song.uri ?? "")));

      notifyListeners();
    }
  }

  void checkAndRemoveFavourite(int index) {
    if (index < staticData.favouriteTracksPlaylist.length) {
      staticData.favouriteTracksPlaylist.removeAt(index);

      staticData.favouriteSongModelMapping.remove(index);
    }
    notifyListeners();
  }

  bool isFavourite(SongModel song) {
    bool isPresent = false;

    staticData.favouriteSongModelMapping.forEach((key, value) {
      isPresent = (value.title == song.title) ? true : false;
    });

    return isPresent;
  }
}
