import 'package:flutter/material.dart';
import 'package:media_player/provider/audio_notifier.dart';
import 'package:media_player/provider/video_notifier.dart';
import 'package:media_player/screens/audio_player_screen.dart';
import 'package:media_player/screens/video_player_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AudioNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AudioPlayerScreen(),
                    ),
                  );
                },
                child: const Text('Audio PLayer'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const VideoPlayerScreen(),
                    ),
                  );
                },
                child: const Text('Video PLayer'),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
