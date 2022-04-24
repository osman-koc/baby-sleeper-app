import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:babysleeper/app_localizations.dart';
import 'package:babysleeper/constants/const_asset.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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

  CountdownTimerController? timerController;
  bool timerIsActive = false;
  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration _initialtimer = const Duration();

  @override
  void initState() {
    super.initState();
    isPlaying = audioPlayer.state == PlayerState.PLAYING;
  }

  @override
  void dispose() {
    timerController?.dispose();
    super.dispose();
  }

  void timerOnEnd() {
    timerController?.disposeTimer();
    _initialtimer = const Duration();
    timerIsActive = false;
    isPlaying = !timerIsActive;
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

  CountdownTimer counterTextWidget() {
    return CountdownTimer(
      controller: timerController,
      onEnd: timerOnEnd,
      endTime: _endTime,
      textStyle: const TextStyle(fontSize: 28.0),
      endWidget: Text(AppLocalizations.of(context).translate('timer_expire_text')),
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
          AppLocalizations.of(context).translate('pressForPlay') +
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
      label: Text(AppLocalizations.of(context).translate('set_timer')),
      icon: const Icon(Icons.timer),
      onPressed: () {
        timerShowDialog(context);
      },
    );
  }

  setTimerMinute() {
    if (_initialtimer.inMilliseconds > 0) {
      int minutes = _initialtimer.inMinutes;
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * minutes;
      timerController =
          CountdownTimerController(endTime: _endTime, onEnd: timerOnEnd);
      timerIsActive = true;
    } else {
      timerIsActive = false;
    }
    isPlaying = !timerIsActive;
    buttonClickEvent();
  }

  void timerShowDialog(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height /
              (timerIsActive ? 5 : 2),
          child: Column(
            children: [
              timerIsActive
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          counterTextWidget(),
                        ],
                      ),
                    )
                  : timerPickerWidget(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelButton(context),
                  okResetButton(context),
                ],
              ),
            ],
          ),
        );
      },
    );
    // .whenComplete(() {
    //   print(_initialtimer.toString());
    // });
  }

  CupertinoTimerPicker timerPickerWidget() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 1,
      secondInterval: 1,
      initialTimerDuration: _initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          _initialtimer = changedtimer;
        });
      },
    );
  }

  TextButton okResetButton(BuildContext context) {
    if (timerIsActive) {
      return TextButton(
        child: Text(AppLocalizations.of(context).translate('reset')),
        onPressed: () {
          Navigator.of(context).pop();
          timerOnEnd();
        },
      );
    } else {
      return TextButton(
        child: Text(AppLocalizations.of(context).translate('ok')),
        onPressed: () {
          Navigator.of(context).pop();
          setTimerMinute();
        },
      );
    }
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      child: Text(AppLocalizations.of(context).translate('cancel')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  ButtonTheme playButton() {
    return ButtonTheme(
      padding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
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
        Image.asset(getButtonImage(), width: 130),
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
}
