import 'package:babysleeper/constants/app_colors.dart';
import 'package:babysleeper/util/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppSettings {
  static const int id = 3;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF58768b),
    primarySwatch: MaterialColor(0xFF58768b, AppPlatte.buttonBgColors),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF58768b),
    primarySwatch: MaterialColor(0xFF58768b, AppPlatte.buttonBgColors),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    if (locale != null) {
      final currentLocale = supportedLocales
          .firstWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) return currentLocale;
    }
    return supportedLocales.first;
  }
}
