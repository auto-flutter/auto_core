import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:auto_core/auto_core.dart';
import 'package:auto_core/protos/match_positions.pb.dart';
import 'package:auto_core/protos/replay_report_info.pbserver.dart';

import 'tar_key.dart';

class CheckpointMatchError {
  final Uint8List imageOfRecorder;
  final Uint8List imageOfPlayer;
  final RatioRect matchPosition;

  CheckpointMatchError(
      {required this.imageOfRecorder,
      required this.imageOfPlayer,
      required this.matchPosition});
}

class PlaybackReport {
  final ReplayReportInfo basicInfo;
  final List<int>? log;
  final List<CheckpointMatchError> matchErrors;

  PlaybackReport({
    required this.basicInfo,
    this.log,
    required this.matchErrors,
  });

  static Future<PlaybackReport> load(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('File not found');
    }
    Archive archive = TarDecoder().decodeBuffer(InputFileStream(path));

    ReplayReportInfo basicInfo = ReplayReportInfo();
    List<int>? log;
    List<CheckpointMatchError> matchErrors = <CheckpointMatchError>[];

    Map<int, RatioRect> matchPositionMap = <int, RatioRect>{};
    Map<int, List<int>> recorderImage = <int, List<int>>{};
    Map<int, List<int>> playerImage = <int, List<int>>{};

    final iterator = archive.iterator;
    while (iterator.moveNext()) {
      final data = iterator.current.content as List<int>;
      final name = iterator.current.name;
      if (name == TarKey.playbackBasicInfo) {
        basicInfo = ReplayReportInfo.fromBuffer(data);
      } else if (name == TarKey.log) {
        log = data;
      } else if (name.startsWith(TarKey.matchPositionPrefix)) {
        final index =
            int.parse(name.replaceAll(TarKey.matchPositionPrefix, ''));
        matchPositionMap[index] =
            RatioRect.matchPosition(MatchPosition.fromBuffer(data));
      } else if (name.startsWith(TarKey.recorderImgPrefix)) {
        final index = int.parse(name.replaceAll(TarKey.recorderImgPrefix, ''));
        recorderImage[index] = data;
      } else if (name.startsWith(TarKey.playerImgPrefix)) {
        final index = int.parse(name.replaceAll(TarKey.playerImgPrefix, ''));
        playerImage[index] = data;
      }
    }
    matchPositionMap.forEach((key, value) {
      matchErrors.add(CheckpointMatchError(
          imageOfRecorder: Uint8List.fromList(recorderImage[key]!),
          imageOfPlayer: Uint8List.fromList(playerImage[key]!),
          matchPosition: matchPositionMap[key]!));
    });

    return PlaybackReport(
        basicInfo: basicInfo, log: log, matchErrors: matchErrors);
  }

  Future<void> save(String path) async {
    final tarEncoder = TarEncoder();
    OutputStream stream = OutputStream();
    tarEncoder.start(stream);

    final basicInfoData = basicInfo.writeToBuffer();
    tarEncoder.add(ArchiveFile(
        TarKey.playbackBasicInfo, basicInfoData.length, basicInfoData));

    if (log != null) {
      tarEncoder.add(ArchiveFile(TarKey.log, log!.length, log));
    }

    for (int i = 0; i < matchErrors.length; i++) {
      final error = matchErrors[i];
      final mp = error.matchPosition.toMatchPosition();
      final mpData = mp.writeToBuffer();
      tarEncoder.add(ArchiveFile(
          '${TarKey.matchPositionPrefix}$i', mpData.length, mpData));
      tarEncoder.add(ArchiveFile('${TarKey.recorderImgPrefix}$i',
          error.imageOfRecorder.length, error.imageOfRecorder));
      tarEncoder.add(ArchiveFile('${TarKey.playerImgPrefix}$i',
          error.imageOfPlayer.length, error.imageOfPlayer));
    }

    tarEncoder.finish();

    final file = File(path);
    await file.writeAsBytes(stream.getBytes());
  }
}
