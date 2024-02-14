class AppAssets {
  static const String appLogo = 'assets/icons/appicon.png';
  static const String defaultUserAvatar = 'assets/img/avatar.png';
  static const String playButtonActive = 'assets/img/play-button-active.png';
  static const String playButtonPassive = 'assets/img/play-button-passive.png';

  static String playButton(bool isActive) => isActive ? playButtonActive : playButtonPassive;
}
