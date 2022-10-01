import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayerController extends GetxController {
  List<Audio> audioList = [];

  final _audioQuery = OnAudioQuery();

  requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
  }

  getMusicFromLibrary() async {
    requestPermission();
    List<SongModel> songModel = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    Uint8List? image;
    for (var element in songModel) {
      image = await _audioQuery.queryArtwork(
        element.id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
      );
      // if (image != null) {
      //   Get.log(image.toString());
      // }
      audioList.add(
        Audio.file(
          element.uri.toString(),
          metas: Metas(
            title: element.title,
            artist: element.artist,
            album: element.album,
            extra: {"image": image},
          ),
        ),
      );
    }
    update();
  }

  Future<PaletteGenerator> getImageColors(AssetsAudioPlayer player) async {
    if (player.getCurrentAudioextra["image"] != null) {
      var paletteGenerator =
          await PaletteGenerator.fromImageProvider(MemoryImage(player.getCurrentAudioextra['image']));
      return paletteGenerator;
    } else {
      return PaletteGenerator.fromColors([PaletteColor(Colors.pink, 1)]);
    }
  }

  @override
  void onInit() {
    getMusicFromLibrary();
    super.onInit();
  }
}
