import 'dart:io';

import 'package:logging/logging.dart';

final Logger _log = Logger('CommandUtil');

class CommandUtil {
  static Future<bool> checkCommandIsExist(String command) async {
    try {
      late final ProcessResult result;
      if(Platform.isWindows){
        result = await Process.run('where', [command],
            runInShell: true);
      }else{
        result = await Process.run('command', ['-v', command],
            runInShell: true);
      }
      if(result.exitCode==0){
        return true;
      } else {
        _log.info(result.stdout);
        _log.severe(result.stderr);
        return false;
      }
    } on ProcessException catch (e) {
      _log.info(e);
      return false;
    }
  }
}
