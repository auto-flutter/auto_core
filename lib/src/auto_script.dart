import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:auto_core/protos/dependencies.pbserver.dart';
import 'package:auto_core/protos/match_positions.pbserver.dart';
import 'package:auto_core/protos/script_meta_data.pbserver.dart';
import 'package:auto_core/src/tar_key.dart';

class AutoScript {
  final List<int> record;
  final List<Checkpoint> checkpoints;
  final ScriptMetaData metaData;
  final List<String> dependencies;

  AutoScript(
      {required this.record,
      required this.checkpoints,
      required this.metaData,
      required this.dependencies});

  static Future<AutoScript> load(String path) async {
    // return AutoScript(
    //     checkpoints: [],
    //     record: [],
    //     metaData: ScriptMetaData(),
    //     dependencies: []);
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('File not found');
    }
    Archive archive = TarDecoder().decodeBuffer(InputFileStream(path));

    List<int> record = [];
    ScriptMetaData scriptMetaData = ScriptMetaData();
    SnapshotMatchPositions snapshotMatchPositions = SnapshotMatchPositions();
    final List<Checkpoint> checkpoints = [];
    final Map<String, Checkpoint> fastFind = <String, Checkpoint>{};
    final List<String> dependencies = [];

    final iterator = archive.iterator;
    while (iterator.moveNext()) {
      final data = iterator.current.content as List<int>;
      if (iterator.current.name == TarKey.allDependency) {
        Dependencies d = Dependencies.fromBuffer(data);
        dependencies.addAll(d.dependencies);
      } else if (iterator.current.name == TarKey.recordStream) {
        record = data;
      } else if (iterator.current.name == TarKey.scriptMetaData) {
        scriptMetaData = ScriptMetaData.fromBuffer(data);
      } else if (iterator.current.name == TarKey.snapshotMatchPositions) {
        snapshotMatchPositions = SnapshotMatchPositions.fromBuffer(data);
      } else if (iterator.current.name.startsWith(TarKey.screenshotPrefix)) {
        final checkpoint = Checkpoint(
            name: iterator.current.name, snapshot: Uint8List.fromList(data));
        checkpoints.add(checkpoint);
        fastFind[checkpoint.name] = checkpoint;
      }
    }
    snapshotMatchPositions.all.forEach((element) {
      fastFind[element.name]
          ?.matchPositions
          .addAll(element.all.map((e) => RatioRect.matchPosition(e)));
    });

    return AutoScript(
        checkpoints: checkpoints,
        metaData: scriptMetaData,
        dependencies: dependencies,
        record: record);
  }

  Future<void> save(String path) async {
    final tarEncoder = TarEncoder();
    OutputStream stream = OutputStream();
    tarEncoder.start(stream);

    Dependencies dependencies = Dependencies();
    dependencies.dependencies.addAll(this.dependencies);
    final dependenciesData = dependencies.writeToBuffer();
    tarEncoder.add(ArchiveFile(
        TarKey.allDependency, dependenciesData.length, dependenciesData));

    tarEncoder.add(ArchiveFile(TarKey.recordStream, record.length, record));

    final metaDataData = metaData.writeToBuffer();
    tarEncoder.add(
        ArchiveFile(TarKey.scriptMetaData, metaDataData.length, metaDataData));

    final snapshotMatchPositions = SnapshotMatchPositions();
    checkpoints.forEach((element) {
      MatchPositions matchPositions = MatchPositions();
      matchPositions.name = element.name;
      matchPositions.all.addAll(element.matchPositions.map((e) => e.toMatchPosition()));
      snapshotMatchPositions.all.add(matchPositions);
    });

    final snapshotMatchPositionsData = snapshotMatchPositions.writeToBuffer();
    tarEncoder.add(ArchiveFile(TarKey.snapshotMatchPositions,
        snapshotMatchPositionsData.length, snapshotMatchPositionsData));

    checkpoints.forEach((element) {
      tarEncoder.add(
          ArchiveFile(element.name, element.snapshot.length, element.snapshot));
    });

    tarEncoder.finish();

    final file = File(path);
    await file.writeAsBytes(stream.getBytes());
  }
}

class Checkpoint {
  final String name;
  final Uint8List snapshot;
  final List<RatioRect> matchPositions = [];

  Checkpoint({required this.name, required this.snapshot});
}

class RatioRect {
  /// The offset ratio of the left edge of this rectangle from the x axis.
  final double leftRatio;

  /// The offset ratio of the top edge of this rectangle from the y axis.
  final double topRatio;

  /// The offset ratio of the left edge of this rectangle from the x axis.
  final double rightRatio;

  /// The offset ratio of the top edge of this rectangle from the y axis.
  final double bottomRatio;

  RatioRect(this.leftRatio, this.topRatio, this.rightRatio, this.bottomRatio);

  // factory RatioRect.resolve(Rect ref, Rect res) {
  //   final h = ref.height;
  //   final w = ref.width;
  //
  //   double left = (res.left - ref.left) / w;
  //   double top = (res.top - ref.top) / h;
  //   double right = (res.right - ref.left) / w;
  //   double bottom = (res.bottom - ref.top) / h;
  //   return RatioRect(left, top, right, bottom);
  // }

  factory RatioRect.matchPosition(MatchPosition matchPosition) {
    return RatioRect(matchPosition.leftRatio, matchPosition.topRatio,
        matchPosition.rightRatio, matchPosition.bottomRatio);
  }

  MatchPosition toMatchPosition() {
    return MatchPosition(
        leftRatio: leftRatio,
        topRatio: topRatio,
        rightRatio: rightRatio,
        bottomRatio: bottomRatio);
  }

  // Rect transform(Rect ref) {
  //   final h = ref.height;
  //   final w = ref.width;
  //   return Rect.fromLTRB(ref.left + (leftRatio * w), ref.top + (topRatio * h),
  //       ref.left + (rightRatio * w), ref.top + (bottomRatio * h));
  // }
}
