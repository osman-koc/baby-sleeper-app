import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:babysleeper/app_localizations.dart';
import 'package:babysleeper/constants/const_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/const_voice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('tr', 'TR'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Sleeper',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final imgActive = ConstAsset.playButtonActive;
  final imgPassive = ConstAsset.playButtonPassive;
  var audioPlayer = AudioPlayer();
  var isPlaying = false;
  int selectedVoiceIndex = 0;

  @override
  void initState() {
    super.initState();
    isPlaying = audioPlayer.state == PlayerState.PLAYING;
  }

  Future playLocal(localFileName) async {
    if (!isPlaying) {
      await audioPlayer.stop();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$localFileName');
      if (!(await file.exists())) {
        final soundData =
            await rootBundle.load(ConstAsset.getAudioLocalPath(localFileName));
        final bytes = soundData.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }
      await audioPlayer.setUrl(file.path, isLocal: true);
      await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      await audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> voiceNames = <String>[
      AppLocalizations.of(context).translate('audio_dandinidastana'),
      AppLocalizations.of(context).translate('audio_justmusic'),
      AppLocalizations.of(context).translate('audio_lullaby'),
      AppLocalizations.of(context).translate('audio_pispiskolik'),
      AppLocalizations.of(context).translate('audio_vacuumcleaner'),
      AppLocalizations.of(context).translate('audio_washingmachine'),
      AppLocalizations.of(context).translate('audio_wootsailorman'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('appName')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              padding: const EdgeInsets.all(40.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20)),
                onPressed: () => setState(() {
                  isPlaying = !isPlaying;
                  playLocal(ConstVoice.getAll[selectedVoiceIndex])
                      .then((value) => (null));
                }),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(getButtonImage(), width: 160),
                    Text(
                      getButtonText(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      )
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: DropdownButton<String>(
                value: voiceNames[selectedVoiceIndex],
                items: voiceNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVoiceIndex = voiceNames.indexOf(value!);
                    isPlaying = false;
                    playLocal(ConstVoice.getAll[selectedVoiceIndex])
                        .then((value) => (null));
                  });
                },
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            Text(
              '\n\n' +
                  AppLocalizations.of(context).translate('pressForHelp') +
                  '\n' +
                  AppLocalizations.of(context).translate('pressForStop'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            Text(
              AppLocalizations.of(context).translate('copyright'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getButtonImage() => isPlaying ? imgActive : imgPassive;

  String getButtonText() {
    return isPlaying
        ? AppLocalizations.of(context).translate('buttonTextStop')
        : AppLocalizations.of(context).translate('buttonTextPlay');
  }
}
