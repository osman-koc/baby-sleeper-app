import 'package:babysleeper/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class ConstVoice {
  static const List<String> getAllPathes = <String>[
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
      AppLocalizations.of(context).translate('audio_dandinidastana'),
      AppLocalizations.of(context).translate('audio_justmusic'),
      AppLocalizations.of(context).translate('audio_lullaby'),
      AppLocalizations.of(context).translate('audio_pispiskolik'),
      AppLocalizations.of(context).translate('audio_vacuumcleaner'),
      AppLocalizations.of(context).translate('audio_washingmachine'),
      AppLocalizations.of(context).translate('audio_wootsailorman'),
      AppLocalizations.of(context).translate('audio_smilebaby'),
      AppLocalizations.of(context).translate('audio_leighamarina'),
    ];
  }
}
