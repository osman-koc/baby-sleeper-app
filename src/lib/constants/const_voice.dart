import 'package:babysleeper/extensions/app_lang.dart';
import 'package:flutter/cupertino.dart';

class ConstVoice {
  static const List<String> getAllPaths = <String>[
    'dandini_dastana.mp3',
    'just_music.mp3',
    'lullaby.mp3',
    'pispis_kolik.mp3',
    'vacuum_cleaner.mp3',
    'washing_machine.mp3',
    'woot_sailorman.mp3',
    'smile_baby.mp3',
    'leigha_marina_lullaby.mp3'
  ];

  static List<String> getAllNames(BuildContext context) {
    return <String>[
      context.translate.audioDandiniDastana,
      context.translate.audioJustMusic,
      context.translate.audioLullaby,
      context.translate.audioPisPiskolik,
      context.translate.audioVacuumCleaner,
      context.translate.audioWashingMachine,
      context.translate.audioWootsailorman,
      context.translate.audioSmileBaby,
      context.translate.audioLeighaMarina,
    ];
  }
}
