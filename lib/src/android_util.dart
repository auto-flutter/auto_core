import 'dart:io';

import 'package:logging/logging.dart';

import 'basic.dart';

final Logger _log = Logger('AndroidUtil');



class AndroidUtil {
  static Future<ProcessResult> startApp(
      {required String package, String? serialno, required String cmd}) async {
    final result = await Process.run(
        cmd,
        [
          if (serialno != null) '-s',
          if (serialno != null) serialno,
          'shell',
          'monkey',
          '-p',
          package,
          '-c',
          'android.intent.category.LAUNCHER',
          '1'
        ],
        runInShell: true);

    return result;
  }

  static Future<ProcessResult> stopApp(
      {required String package, String? serialno, required String cmd}) async {
    final result = await Process.run(
        cmd,
        [
          if (serialno != null) '-s',
          if (serialno != null) serialno,
          'shell',
          'am',
          'force-stop',
          package
        ],
        runInShell: true);
    return result;
  }

  static Future<ProcessResult> restartApp(
      {required String package,
      required String serialno,
      required String cmd}) async {
    final result =
        await stopApp(package: package, serialno: serialno, cmd: cmd);
    if (result.exitCode == 0) {
      return startApp(package: package, serialno: serialno, cmd: cmd);
    } else {
      return result;
    }
  }

  static Future<List<String>> listAllPackages(
      {String? serialno,
      required String cmd,
      bool third = true,
      bool sort = true}) async {
    final result = await Process.run(
        cmd,
        [
          'shell',
          if (serialno != null) '-s',
          if (serialno != null) serialno,
          'pm',
          'list',
          'packages',
          if (third) '-3'
        ],
        runInShell: true);
    if (result.exitCode == Ok) {
      //package:com.example.example
      //package:com.miui.userguide
      //package:com.xiaomi.mibrain.speech
      final List<String> r = <String>[];
      String packageString = result.stdout as String;
      final packagesList = packageString.split('\n');
      for (var packageName in packagesList) {
        if (packageName.contains('package')) {
          r.add(packageName.split(':')[1]);
        }
      }
      if (sort) {
        r.sort();
      }
      return r;
      // packages
    } else {
      return [];
    }
  }

  static Future<List<AndroidDeviceInfo>> listAllDevices(
      {required String cmd}) async {
    final result = await Process.run(cmd, ['devices', '-l'], runInShell: true);
    if (result.exitCode == Ok) {
      //List of devices attached
      // FFK0217503002178       offline transport_id:5
      // ccad64e                device product:grus model:MI_9_SE device:grus transport_id:1
      final List<AndroidDeviceInfo> r = <AndroidDeviceInfo>[];
      String packageString = result.stdout as String;
      final packagesList = packageString.split('\n');
      for (var line in packagesList) {
        if (!line.contains(':')) {
          continue;
        }
        final rr = line.split(RegExp(r'\s+'));
        if (rr.length < 2) {
          continue;
        }
        AndroidDeviceStatus status;
        String serialno;
        String model = '';
        if (rr[1] == 'device') {
          status = AndroidDeviceStatus.online;
        } else if (rr[1] == 'offline') {
          status = AndroidDeviceStatus.offline;
        } else {
          continue;
        }
        serialno = rr[0];
        rr.forEach((element) {
          if (element.contains('model:')) {
            model = element.split(':')[1];
          }
        });
        r.add(AndroidDeviceInfo(status, serialno, model: model));
      }
      return r;
    } else {
      return [];
    }
  }
}

enum AndroidDeviceStatus { online, offline }

class AndroidDeviceInfo {
  AndroidDeviceStatus status;
  String serialno;

  ///e.g: MI_9_SE
  String model;

  AndroidDeviceInfo(this.status, this.serialno, {this.model = ''});

  @override
  String toString() {
    return 'AndroidDeviceInfo{status: $status, serialno: $serialno, model: $model}';
  }
}
