///
//  Generated code. Do not modify.
//  source: playback_report_info.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'app_info.pb.dart' as $0;

class ReplayReportInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReplayReportInfo', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ok')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', protoName: 'errorReason')
    ..aOM<$0.AppInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appInfoOfRecorder', protoName: 'appInfoOfRecorder', subBuilder: $0.AppInfo.create)
    ..aOM<$0.AppInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appInfoOfPlayer', protoName: 'appInfoOfPlayer', subBuilder: $0.AppInfo.create)
    ..hasRequiredFields = false
  ;

  ReplayReportInfo._() : super();
  factory ReplayReportInfo({
    $core.bool? ok,
    $core.String? errorReason,
    $0.AppInfo? appInfoOfRecorder,
    $0.AppInfo? appInfoOfPlayer,
  }) {
    final _result = create();
    if (ok != null) {
      _result.ok = ok;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    if (appInfoOfRecorder != null) {
      _result.appInfoOfRecorder = appInfoOfRecorder;
    }
    if (appInfoOfPlayer != null) {
      _result.appInfoOfPlayer = appInfoOfPlayer;
    }
    return _result;
  }
  factory ReplayReportInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReplayReportInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReplayReportInfo clone() => ReplayReportInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReplayReportInfo copyWith(void Function(ReplayReportInfo) updates) => super.copyWith((message) => updates(message as ReplayReportInfo)) as ReplayReportInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReplayReportInfo create() => ReplayReportInfo._();
  ReplayReportInfo createEmptyInstance() => create();
  static $pb.PbList<ReplayReportInfo> createRepeated() => $pb.PbList<ReplayReportInfo>();
  @$core.pragma('dart2js:noInline')
  static ReplayReportInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplayReportInfo>(create);
  static ReplayReportInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ok => $_getBF(0);
  @$pb.TagNumber(1)
  set ok($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOk() => $_has(0);
  @$pb.TagNumber(1)
  void clearOk() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorReason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);

  @$pb.TagNumber(3)
  $0.AppInfo get appInfoOfRecorder => $_getN(2);
  @$pb.TagNumber(3)
  set appInfoOfRecorder($0.AppInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAppInfoOfRecorder() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppInfoOfRecorder() => clearField(3);
  @$pb.TagNumber(3)
  $0.AppInfo ensureAppInfoOfRecorder() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.AppInfo get appInfoOfPlayer => $_getN(3);
  @$pb.TagNumber(4)
  set appInfoOfPlayer($0.AppInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAppInfoOfPlayer() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppInfoOfPlayer() => clearField(4);
  @$pb.TagNumber(4)
  $0.AppInfo ensureAppInfoOfPlayer() => $_ensure(3);
}

