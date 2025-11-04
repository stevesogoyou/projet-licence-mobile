import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:ui';
import 'package:voiture/bottomNav.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoitureLuxe(),
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40),
          ),
        ),
      ),
    );
  }
}

class VoitureLuxe extends StatefulWidget {
  @override
  _VoitureLuxeState createState() => _VoitureLuxeState();
}

class _VoitureLuxeState extends State<VoitureLuxe> {
  late ChewieController _audiChewieController;
  late ChewieController _mercedesChewieController;
  late ChewieController _bmwVideoChewieController;

  ChewieController _createChewieController(String videoAsset) {
    final videoController = VideoPlayerController.asset(videoAsset)
      ..initialize().then((_) {
        setState(() {});
      });

    return ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      looping: false,
      showControls: false,
    );
  }

  @override
  void initState() {
    super.initState();

    _audiChewieController = _createChewieController('assets/videos/Audi.mp4');
    _mercedesChewieController = _createChewieController('assets/videos/benz.mp4');
    _bmwVideoChewieController = _createChewieController('assets/videos/bmw.mp4');
  }

  @override
  void dispose() {
    _audiChewieController.dispose();
    _mercedesChewieController.dispose();
    _bmwVideoChewieController.dispose();
    super.dispose();
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Chewie(controller: _audiChewieController),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12, // Couleur de fond transparente
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Ombre légère
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _audiChewieController.play();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Fond transparent
                      elevation: 0, // Pas d'élévation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Coins arrondis
                      ),
                    ),
                    child: Text(
                      'AUDI',
                      style: TextStyle(
                        color: Colors.white, // Couleur du texte
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),







          Container(
            height: 1,
            color: Theme.of(context).textTheme.button!.color,
          ),
          SizedBox(height: 16), // Espace vertical entre les Expanded
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Chewie(controller: _mercedesChewieController),
                ElevatedButton(
                  onPressed: () {
                    _mercedesChewieController.play();
                  },
                  child: Text('MERCEDES-BENZ'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Espace vertical entre les Expanded
          Container(
            height: 1,
            color: Theme.of(context).textTheme.button!.color,
          ),
          SizedBox(height: 16), // Espace vertical entre les Expanded
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Chewie(controller: _bmwVideoChewieController),
                ElevatedButton(
                  onPressed: () {
                    _bmwVideoChewieController.play();
                  },
                  child: Text('BMW'),
                ),
              ],
            ),
          ),
        ],
      ),

    );

  }
}
