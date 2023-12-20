import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:media_player/provider/audio_notifier.dart';
import 'package:media_player/utils/utils.dart';
import 'package:media_player/widget/audio_controller_widget.dart';
import 'package:media_player/widget/buffer_slider_controller_widget.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final AudioPlayer audioPlayer;
  late final Source audioSource;

  @override
  void initState() {
    final provider = context.read<AudioNotifier>();
    // TODO notice ini yak
    /*
    final Source urlSource = UrlSource("tautan_berkas");
    final Source deviceSource = DeviceFileSource("path_direktori_berkas");
    final Source assetSource = AssetSource("nama_berkas");
    final Source bytesSource = BytesSource(bytes);
    */

    audioPlayer = AudioPlayer();
    audioSource = AssetSource("cricket.wav"); /// asset
    audioPlayer.setSource(audioSource);
    // audioPlayer = AudioPlayer();
    // audioSource = UrlSource(
    //   /// url
    //   "https://github.com/dicodingacademy/assets/raw/main/flutter_intermediate_academy/bensound_ukulele.mp3",
    // );
    // audioPlayer.setSource(audioSource);

    audioPlayer.onPlayerStateChanged.listen((state) {
      provider.isPlay = state == PlayerState.playing;
      if (state == PlayerState.stopped) {
        provider.position = Duration.zero;
      }
    });
    audioPlayer.onDurationChanged.listen((duration) {
      provider.duration = duration;
    });
    audioPlayer.onPositionChanged.listen((position) {
      provider.position = position;
    });
    audioPlayer.onPlayerComplete.listen((_) {
      provider.position = Duration.zero;
      provider.isPlay = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player Project"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// todo-04-ui-01: cover with Consumer widget to update the value
          Consumer<AudioNotifier>(
            builder: (context, provider, child) {
              /// todo-04-ui-02: fill the value based on provider value
              /// you can add the utils file to support text formatting
              final duration = provider.duration;
              final position = provider.position;

              return BufferSliderControllerWidget(
                maxValue: duration.inSeconds.toDouble(),
                currentValue: position.inSeconds.toDouble(),
                minText: durationToTimeString(position),
                maxText: durationToTimeString(duration),
                onChanged: (value) async {
                  /// todo-04-ui-03: update the audio player when slider is move
                  final newPosition = Duration(seconds: value.toInt());
                  await audioPlayer.seek(newPosition);

                  /// todo-04-ui-04: resume the audio player after user move the slider
                  await audioPlayer.resume();
                },
              );
            },
          ),

          /// todo-04-ui-05: cover with Consumer widget to update the value
          Consumer<AudioNotifier>(
            builder: (context, provider, child) {
              final bool isPlay = provider.isPlay;
              return AudioControllerWidget(
                onPlayTapped: () {
                  /// todo-04-ui-07: play the player when user tap the pause button
                  audioPlayer.play(audioSource);
                },
                onPauseTapped: () {
                  /// todo-04-ui-08: pause the player when user tap the play button
                  audioPlayer.pause();
                },
                onStopTapped: () {
                  /// todo-04-ui-09: stop the player when user tap the stop button
                  audioPlayer.stop();
                },

                /// todo-04-ui-096 update the isPlay state
                isPlay: isPlay,
              );
            },
          ),
        ],
      ),
    );
  }
}