import 'dart:io';

import 'package:babysleeper/constants/const_asset.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> getSoundFilePath(localFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$localFileName');
    if (!(await file.exists())) {
      await fileWriteAsBytes(localFileName, file);
    }
    return file.path;
  }

  static Future<void> fileWriteAsBytes(localFileName, File file) async {
    final soundData =
        await rootBundle.load(ConstAsset.getAudioLocalPath(localFileName));
    final bytes = soundData.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }
}