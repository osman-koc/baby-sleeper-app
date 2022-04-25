class ConstAsset {
  static const String playButtonActive = 'assets/img/play-button-active.png';
  static const String playButtonPassive = 'assets/img/play-button-passive.png';

  static String getAudioLocalPath(String localFileName) =>
      'assets/audios/$localFileName';
}
