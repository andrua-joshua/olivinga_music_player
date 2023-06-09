import 'package:flutter/material.dart';
import 'package:learningdart/routes/current_playing_playlist.dart';
import 'package:learningdart/routes/home_screen.dart';
import 'package:learningdart/routes/music_player.dart';
import 'package:learningdart/routes/start_screen.dart';

///
///This class is responsible for handling all the routings in the application
///
///
//ignore: camel_case_types
class RouteGenerator {
  static const String startscreen = "/";
  static const String homescreen = "/homeScreen";
  static const String playerscreen = "/player";
  static const String playingListscreen = "/playingList";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startscreen:
        return MaterialPageRoute(builder: (context) => const startScreen());

      case homescreen:
        return MaterialPageRoute(builder: (context) => const homeScreen());

      case playerscreen:
        return MaterialPageRoute(builder: (context) => const playerScreen());

        case playingListscreen:
        return MaterialPageRoute(builder: (context) => const playingListScreen());

      default:
        return MaterialPageRoute(builder: (context) => const startScreen());
    }
  }
}
