import 'package:audioplayers/audioplayers.dart';
import 'package:babysleeper/constants/app_colors.dart';
import 'package:babysleeper/constants/const_asset.dart';
import 'package:babysleeper/constants/const_voice.dart';
import 'package:babysleeper/extensions/app_lang.dart';
import 'package:babysleeper/helpers/file_helper.dart';
import 'package:babysleeper/screens/components/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool isPlaying = false;
  var audioPlayer = AudioPlayer();
  int selectedVoiceIndex = 0;

  final imgActive = ConstAsset.playButtonActive;
  final imgPassive = ConstAsset.playButtonPassive;

  CountdownTimerController? timerController;
  bool timerIsActive = false;
  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration _initialtimer = const Duration();

  @override
  void initState() {
    super.initState();
    isPlaying = audioPlayer.state == PlayerState.playing;
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
    List<String> voiceNames = ConstVoice.getAllNames(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(context.translate.appName),
      // ),
      appBar: _buildAppBar(),
      drawer: const SideMenu(),
      floatingActionButton: playTimerModalButton(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            playButton(),
            audioDropdown(voiceNames),
            descriptionTexts(context),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors(context).appDefaultTextColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors(context).appDefaultBgColor),
      title: Text(context.translate.appName),
    );
  }

  Future playLocal(localFileName) async {
    if (!isPlaying) {
      await audioPlayer.stop();
      timerIsActive = false;
    } else {
      String filePath = await FileHelper.getSoundFilePath(localFileName);
      await audioPlayer.setSourceUrl(filePath);
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
    }
  }

  CountdownTimer counterTextWidget() {
    return CountdownTimer(
      controller: timerController,
      onEnd: timerOnEnd,
      endTime: _endTime,
      textStyle: const TextStyle(fontSize: 28.0),
      endWidget: Text(context.translate.timerExpireText),
    );
  }

  Text descriptionTexts(BuildContext context) {
    return Text(
      '\n\n${context.translate.pressForPlay}\n${context.translate.pressForStop}',
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
            playLocal(ConstVoice.getAllPaths[selectedVoiceIndex])
                .then((value) => (null));
          });
        },
        style:
            TextStyle(color: AppColors(context).dropdownButtonBg, fontSize: 20),
      ),
    );
  }

  FloatingActionButton playTimerModalButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        context.translate.setTimer,
        style: TextStyle(color: AppColors(context).white),
      ),
      icon: Icon(
        Icons.timer,
        color: AppColors(context).white,
      ),
      backgroundColor: AppColors(context).timerButtonBg,
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
      backgroundColor: AppColors(context).timerBg,
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
        child: Text(
          context.translate.reset,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          timerOnEnd();
        },
      );
    } else {
      return TextButton(
        child: Text(
          context.translate.ok,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          setTimerMinute();
        },
      );
    }
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      child: Text(
        context.translate.cancel,
        style: const TextStyle(fontSize: 18),
      ),
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
          backgroundColor: AppColors(context).timerButtonBg,
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
          style: TextStyle(color: AppColors(context).white, fontSize: 18),
        )
      ],
    );
  }

  String getButtonImage() => isPlaying ? imgActive : imgPassive;
  String getButtonText() {
    return isPlaying
        ? context.translate.buttonTextStop
        : context.translate.buttonTextPlay;
  }

  void buttonClickEvent() {
    try {
      setState(() {
        isPlaying = !isPlaying;
        playLocal(ConstVoice.getAllPaths[selectedVoiceIndex])
            .then((value) => (null));
      });
    } catch (e) {
      isPlaying = false;
    }
  }
}
