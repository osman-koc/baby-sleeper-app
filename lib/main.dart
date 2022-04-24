import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:babysleeper/app_localizations.dart';
import 'package:babysleeper/constants/const_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
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

  final _numberInput = TextEditingController(text: '0');
  CountdownTimerController? timerController;
  bool timerIsActive = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  @override
  void initState() {
    super.initState();
    isPlaying = audioPlayer.state == PlayerState.PLAYING;

    // timerIsActive = true;
    // timerController =
    //     CountdownTimerController(endTime: endTime, onEnd: timerOnEnd);
  }

  @override
  void dispose() {
    timerController?.dispose();
    super.dispose();
  }

  void timerOnEnd() {
    Navigator.of(context).pop();
    _numberInput.text = '0';
    timerIsActive = false;
    timerController?.disposeTimer();
    buttonClickEvent();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _voiceNames = ConstVoice.getAllNames(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('appName')),
      ),
      floatingActionButton: playTimerModalButton(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            playButton(),
            audioDropdown(_voiceNames),
            descriptionTexts(context),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            footerText(context),
          ],
        ),
      ),
    );
  }

  /* FILE METHODS */
  Future playLocal(localFileName) async {
    if (!isPlaying) {
      await audioPlayer.stop();
    } else {
      String filePath = await getSoundFilePath(localFileName);
      await audioPlayer.setUrl(filePath, isLocal: true);
      await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      await audioPlayer.resume();
    }
  }

  Future<String> getSoundFilePath(localFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$localFileName');
    if (!(await file.exists())) {
      await fileWriteAsBytes(localFileName, file);
    }
    return file.path;
  }

  Future<void> fileWriteAsBytes(localFileName, File file) async {
    final soundData =
        await rootBundle.load(ConstAsset.getAudioLocalPath(localFileName));
    final bytes = soundData.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }
  /* FILE METHODS */

  /* THEME METHODS */
  CountdownTimer timerCountWidget() {
    return CountdownTimer(
      controller: timerController,
      onEnd: timerOnEnd,
      endTime: endTime,
    );
  }

  Text footerText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).translate('copyright'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 10.0,
      ),
    );
  }

  Text descriptionTexts(BuildContext context) {
    return Text(
      '\n\n' +
          AppLocalizations.of(context).translate('pressForHelp') +
          '\n' +
          AppLocalizations.of(context).translate('pressForStop'),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Container audioDropdown(List<String> voiceNames) {
    return Container(
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
            playLocal(ConstVoice.getAllPathes[selectedVoiceIndex])
                .then((value) => (null));
          });
        },
        style: const TextStyle(color: Colors.black87, fontSize: 20),
      ),
    );
  }

  FloatingActionButton playTimerModalButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('Set Timer'),
      icon: const Icon(Icons.timer),
      onPressed: () {
        timerShowDialog(context);
      },
    );
    // return FloatingActionButton(
    //   onPressed: () {
    //    timerSettingsShowDialog(context);
    //   },
    //   child: const Icon(Icons.timer),
    //   tooltip: 'Set Timer',
    // );
  }

  void timerShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Close after this time (min)'),
          content: timerIsActive
              ? timerCountWidget()
              : inputMinuteForTimerInModal(context),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            timerIsActive
                ? TextButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      timerOnEnd();
                      Navigator.of(context).pop();
                    },
                  )
                : TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      setTimerMinute();
                      Navigator.of(context).pop();
                    },
                  ),
          ],
        );
      },
    );
  }

  setTimerMinute() {
    if (int.parse(_numberInput.text) > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * 60 * int.parse(_numberInput.text);
      timerController =
          CountdownTimerController(endTime: endTime, onEnd: timerOnEnd);
      timerIsActive = true;
    } else {
      timerIsActive = false;
    }
  }

  Widget inputMinuteForTimerInModal(BuildContext context) {
    return NumberInputWithIncrementDecrement(
        controller: _numberInput,
        scaleWidth: 1,
        scaleHeight: 1,
        initialValue: 0,
        min: 0,
        isInt: true);
  }

  ButtonTheme playButton() {
    return ButtonTheme(
      padding: const EdgeInsets.all(30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        ),
        onPressed: buttonClickEvent,
        child: buttonContent(),
      ),
    );
  }

  Column buttonContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(getButtonImage(), width: 160),
        const Padding(padding: EdgeInsets.all(8)),
        Text(
          getButtonText(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }

  String getButtonImage() => isPlaying ? imgActive : imgPassive;
  String getButtonText() {
    return isPlaying
        ? AppLocalizations.of(context).translate('buttonTextStop')
        : AppLocalizations.of(context).translate('buttonTextPlay');
  }

  void buttonClickEvent() => setState(() {
        isPlaying = !isPlaying;
        playLocal(ConstVoice.getAllPathes[selectedVoiceIndex])
            .then((value) => (null));
      });
  /* THEME METHODS */
}
