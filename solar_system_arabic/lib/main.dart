import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'planet.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Système Solaire',
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: PlanetListScreen(),
      ),
    );
  }
}

class PlanetListScreen extends StatefulWidget {
  const PlanetListScreen({super.key});

  @override
  _PlanetListScreenState createState() => _PlanetListScreenState();
}

class _PlanetListScreenState extends State<PlanetListScreen> {
  late Future<List<Planet>> planets;
  late VideoPlayerController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    planets = ApiService().fetchPlanets();

    // Vidéo en arrière-plan
    _controller = VideoPlayerController.asset('assets/bb.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.setLooping(true);
    _controller.play();
    _playSound();
  }

  // Lecture du son en boucle
  void _playSound() async {
    try {
      await _audioPlayer.setAsset('assets/sound.mp3');
      _audioPlayer.play();
    } catch (e) {
      print("Erreur de chargement de l'audio: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lecture de la vidéo en arrière-plan
          _controller.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
              : Center(child: CircularProgressIndicator()),

          // Affichage des planètes depuis le backend
          FutureBuilder<List<Planet>>(
            future: planets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('خطأ: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('لا توجد بيانات'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Planet planet = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            planet.name,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planet.description,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'المسافة من الشمس: ${planet.distanceFromSun}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
