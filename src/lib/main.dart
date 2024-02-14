import 'package:audioplayers/audioplayers.dart';
import 'package:babysleeper/constants/app_settings.dart';
import 'package:babysleeper/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  AudioPlayer.global.setAudioContext(AudioContextConfig().build());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Sleeper',
      home: const MyHomePage(),
      theme: AppSettings.lightTheme,
      darkTheme: AppSettings.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      supportedLocales: AppSettings.supportedLocales,
      localizationsDelegates: AppSettings.localizationsDelegates,
      localeResolutionCallback: AppSettings.localeResolutionCallback,
    );
  }
}
