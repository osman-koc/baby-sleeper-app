import 'package:babysleeper/util/localization.dart';
import 'package:flutter/material.dart';

class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get appDeveloper => _appLocalizations.translate(key: 'app_developer');
  String get appWebsite => _appLocalizations.translate(key: 'app_website');
  String get appMail => _appLocalizations.translate(key: 'app_email');
  String get about => _appLocalizations.translate(key: 'about');
  String get aboutAppTitle =>
      _appLocalizations.translate(key: 'about_app_title');
  String get developedBy => _appLocalizations.translate(key: 'developedby');
  String get contact => _appLocalizations.translate(key: 'contact');
  String get close => _appLocalizations.translate(key: 'close');
  String get myApps => _appLocalizations.translate(key: 'my_apps');
  String get myAppsTitle => _appLocalizations.translate(key: 'my_apps_title');
  String get dataIsLoading => _appLocalizations.translate(key: 'data_loading');
  String get dataLoadError => _appLocalizations.translate(key: 'data_load_error');

  String get audioDandiniDastana =>
      _appLocalizations.translate(key: 'audio_dandinidastana');
  String get audioJustMusic =>
      _appLocalizations.translate(key: 'audio_justmusic');
  String get audioLullaby => _appLocalizations.translate(key: 'audio_lullaby');
  String get audioPisPiskolik =>
      _appLocalizations.translate(key: 'audio_pispiskolik');
  String get audioVacuumCleaner =>
      _appLocalizations.translate(key: 'audio_vacuumcleaner');
  String get audioWashingMachine =>
      _appLocalizations.translate(key: 'audio_washingmachine');
  String get audioWootsailorman =>
      _appLocalizations.translate(key: 'audio_wootsailorman');
  String get audioSmileBaby =>
      _appLocalizations.translate(key: 'audio_smilebaby');
  String get audioLeighaMarina =>
      _appLocalizations.translate(key: 'audio_leighamarina');

  String get timerExpireText =>
      _appLocalizations.translate(key: 'timer_expire_text');
  String get copyright => _appLocalizations.translate(key: 'copyright');
  String get pressForPlay => _appLocalizations.translate(key: 'pressForPlay');
  String get pressForStop => _appLocalizations.translate(key: 'pressForStop');
  String get setTimer => _appLocalizations.translate(key: 'set_timer');
  String get reset => _appLocalizations.translate(key: 'reset');
  String get ok => _appLocalizations.translate(key: 'ok');
  String get cancel => _appLocalizations.translate(key: 'cancel');
  String get buttonTextStop => _appLocalizations.translate(key: 'buttonTextStop');
  String get buttonTextPlay => _appLocalizations.translate(key: 'buttonTextPlay');
  String get welcome => _appLocalizations.translate(key: 'welcome');
  String get home => _appLocalizations.translate(key: 'home');
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
