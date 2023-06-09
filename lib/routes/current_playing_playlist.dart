import 'package:flutter/material.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:learningdart/widgets/widgets.dart';

///
///This will be responsible for showing the list
///of the current playing tracks
///
//ignore: camel_case_types
class playingListScreen extends StatelessWidget {
  const playingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Current playing list", style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
          itemCount: staticData.isFavourites? staticData.favouriteTracksPlaylist.length+1:staticData.allTracksPlaylist.length+1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Text("", style: TextStyle(color: Colors.white,),);
            }

            return trackWidget(
                favourite: staticData.isFavourites, index: index - 1,
                isplaylist: true,);
          }),
    );
  }
}
