import 'package:flutter/material.dart';
import 'package:learningdart/providers_and_notifiers/static_data.dart';
import 'package:learningdart/routes.dart';
import 'package:learningdart/widgets/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

///
///this is for displaying the playing track
///
//ignore: camel_case_types
class playerScreen extends StatelessWidget {
  const playerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black,
            Color.fromARGB(255, 32, 32, 32),
            Color.fromARGB(255, 24, 43, 48)
          ])),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
            )),
        title: const Text(
          "Playing now",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(
                  context, RouteGenerator.playingListscreen),
              icon: const Icon(
                Icons.queue_music_outlined,
                color: Colors.grey,
              )),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: staticData.player.currentIndexStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("There was an error loading track index"));
                }
                if (snapshot.hasData) {
                  return Container(
                    //constraints: const BoxConstraints.expand(),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black,
                      Color.fromARGB(255, 32, 32, 32),
                      Color.fromARGB(255, 24, 43, 48)
                    ])),
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 61, 59, 59),
                              image: const DecorationImage(
                              image: AssetImage("assets/images/nan.jpg"))),
                          //child:  Image.asset("assets/images/nan.jpg")
                        )),
                        const SizedBox(
                          height: 15,
                        ),
                        const trackDetailsWidget()
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}
