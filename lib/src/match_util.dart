import 'dart:io';

import 'package:auto_core/protos/replay_report_info.pbserver.dart';
import 'package:auto_core/src/auto_script.dart';
import 'package:image/image.dart' as img;
import 'package:logging/logging.dart';

import 'basic.dart';
import 'playback_report.dart';
import 'raw_playback_data.dart';

final Logger _logger = Logger('MatchUtil');

class MatchUtil {
  static Future<bool> imageMatch(String srcPath, String searchPath,
      {double threshold = 0.8}) async {
    final args = [
      'match',
      '--src',
      srcPath,
      '--search',
      searchPath,
      '--threshold',
      threshold.toString()
    ];
    final result = await Process.run(mainCmd, args, runInShell: true);
    if (result.exitCode != Ok) {
      _logger.severe('imageMatch', 'command: $mainCmd ${args.join(' ')}');
      _logger.severe('imageMatch', result.stderr);
    }
    _logger.info(result.stdout);
    return result.exitCode == Ok;
  }

  static Future<PlaybackReport> match(
      AutoScript autoScript, RawPlaybackResult rawReplayResult,
      {double threshold = 0.8}) async {
    if (rawReplayResult.snapshots.keys.length !=
        autoScript.checkpoints.length) {
      return PlaybackReport(
          matchErrors: [],
          log: rawReplayResult.log,
          basicInfo: ReplayReportInfo(
              ok: false,
              appInfoOfPlayer: autoScript.metaData.appInfo,
              appInfoOfRecorder: rawReplayResult.appInfo,
              errorReason:
                  'The number of snapshots is not equal: expect ${autoScript.checkpoints.length} actual ${rawReplayResult.snapshots.length} '));
    }

    for (var entry in rawReplayResult.snapshots.entries) {
      final index = autoScript.checkpoints
          .indexWhere((element) => element.name == entry.key);
      if (index == -1) {
        return PlaybackReport(
            matchErrors: [],
            log: rawReplayResult.log,
            basicInfo: ReplayReportInfo(
                ok: false,
                appInfoOfPlayer: autoScript.metaData.appInfo,
                appInfoOfRecorder: rawReplayResult.appInfo,
                errorReason:
                    'The corresponding snapshot was not found and cannot be matched'));
      }

      final checkpoint = autoScript.checkpoints[index];
      if (checkpoint.matchPositions.isEmpty) {
        continue;
      }
      File sourceFile = createTempFile(
          '_source_${DateTime.now().microsecondsSinceEpoch}.png');
      await sourceFile.writeAsBytes(entry.value);

      File searchFile = createTempFile(
          '_search_${DateTime.now().microsecondsSinceEpoch}.png');
      img.Image searchBaseImage = img.decodeImage(checkpoint.snapshot)!;

      for (var match in checkpoint.matchPositions) {
        double dx = match.leftRatio * searchBaseImage.width;
        double dy = match.topRatio * searchBaseImage.height;
        double width =
            (match.rightRatio - match.leftRatio) * searchBaseImage.width;
        double height =
            (match.bottomRatio - match.topRatio) * searchBaseImage.height;

        assert(width != 0 && width <= searchBaseImage.width);
        assert(height != 0 && height <= searchBaseImage.height);

        final cropImage = img.copyCrop(searchBaseImage, dx.toInt(), dy.toInt(),
            width.toInt(), height.toInt());
        await searchFile.writeAsBytes(img.encodePng(cropImage));

        final result = await imageMatch(
            sourceFile.absolute.path, searchFile.absolute.path,
            threshold: threshold);
        if (!result) {
          sourceFile.delete();
          searchFile.delete();
          return PlaybackReport(
              matchErrors: [
                CheckpointMatchError(
                    matchPosition: match,
                    imageOfPlayer: entry.value,
                    imageOfRecorder: checkpoint.snapshot),
              ],
              log: rawReplayResult.log,
              basicInfo: ReplayReportInfo(
                  ok: false,
                  errorReason: 'Snapshot does not match',
                  appInfoOfPlayer: rawReplayResult.appInfo,
                  appInfoOfRecorder: autoScript.metaData.appInfo));
        }
      }
      sourceFile.delete();
      searchFile.delete();
    }

    return PlaybackReport(
        matchErrors: [],
        log: rawReplayResult.log,
        basicInfo: ReplayReportInfo(
            ok: true,
            appInfoOfPlayer: rawReplayResult.appInfo,
            appInfoOfRecorder: autoScript.metaData.appInfo));
  }
}
