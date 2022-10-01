import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'theme/app_theme.dart';
import 'views/song_list_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const SongListView(),
    );
  }
}
