import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

///
///This is where all the static data shall be placed
///
//ignore: camel_case_types
class staticData {
  static bool isFavourites = false;
  static final player = AudioPlayer();
  static final OnAudioQuery audioQuery = OnAudioQuery();
  
  static final allTracksPlaylist = ConcatenatingAudioSource(
      children: [],
      useLazyPreparation: true,
      shuffleOrder: LinearShuffleOrder());
  static final favouriteTracksPlaylist = ConcatenatingAudioSource(
      children: [],
      useLazyPreparation: true,
      shuffleOrder: LinearShuffleOrder());

  static final Map<int, SongModel> allTrackSongModelMapping = {};
  static final Map<int, SongModel> favouriteSongModelMapping = {};
  static final Map<String, ConcatenatingAudioSource> playlists = {};
  static final Map<String, Map<int, SongModel>> playlistsSongModelMapping = {};
}
