import 'dart:math' as math;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../controller/player_controller.dart';
import 'player_page.dart';

class SongListView extends StatefulWidget {
  const SongListView({super.key});

  @override
  State<SongListView> createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> with SingleTickerProviderStateMixin {
  final player = AssetsAudioPlayer();

  bool isPlaying = true;

  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  final playerController = Get.put(PlayerController());

  @override
  void initState() {
    openPlayer();
    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
    super.initState();
  }

  void openPlayer() async {
    await player.open(
      Playlist(audios: playerController.audioList),
      autoStart: false,
      showNotification: true,
      loopMode: LoopMode.playlist,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: GetBuilder<PlayerController>(builder: (layerController) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SafeArea(
                child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.white30,
                  height: 0,
                  thickness: 1,
                  indent: 85,
                );
              },
              itemCount: playerController.audioList.length,
              itemBuilder: (context, index) {
                final audio = playerController.audioList[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Text(
                      audio.metas.title!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      audio.metas.artist!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: audio.metas.extra?['image'] != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: MemoryImage(audio.metas.extra?['image']),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.primaryColor,
                              child: const Icon(Icons.music_note),
                            ),
                    ),
                    // onTap: () async {
                    //   await player.open(
                    //     Playlist(audios: playerController.audioList, startIndex: index),
                    //     autoStart: true,
                    //     showNotification: true,
                    //     loopMode: LoopMode.playlist,
                    //   );
                    // },
                    onTap: () async {
                      await player.open(
                        Playlist(audios: playerController.audioList, startIndex: index),
                        autoStart: true,
                        showNotification: true,
                        loopMode: LoopMode.playlist,
                      );
                      setState(() {
                        player.getCurrentAudioextra;
                        player.getCurrentAudioTitle;
                      });
                    },
                  ),
                );
              },
            )),
            FutureBuilder<PaletteGenerator>(
              future: playerController.getImageColors(player),
              builder: (context, snapshot) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                  height: 75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: const Alignment(0, 5),
                      colors: [
                        snapshot.data?.lightMutedColor?.color ?? Colors.grey,
                        snapshot.data?.mutedColor?.color ?? Colors.grey,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: AnimatedBuilder(
                      animation: _animationController,
                      builder: (_, child) {
                        if (!isPlaying) {
                          _animationController.stop();
                        } else {
                          _animationController.forward();
                          _animationController.repeat();
                        }
                        return Transform.rotate(angle: _animationController.value * 2 * math.pi, child: child);
                      },
                      child: player.getCurrentAudioextra['image'] != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: MemoryImage(player.getCurrentAudioextra['image']),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.primaryColor,
                              child: const Icon(Icons.music_note),
                            ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => PlayerPage(
                          player: player,
                        ),
                      ),
                    ),
                    title: Text(player.getCurrentAudioTitle),
                    subtitle: Text(player.getCurrentAudioArtist),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await player.playOrPause();
                      },
                      icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
