import 'dart:typed_data';

import 'package:auto_core/protos/app_info.pb.dart';

class RawPlaybackResult {
  final Map<String,Uint8List> snapshots;
  final List<int>? log;
  final AppInfo appInfo;

  RawPlaybackResult( {required this.snapshots, this.log,required this.appInfo});
}
