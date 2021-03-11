///
//  Generated code. Do not modify.
//  source: match_positions.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SnapshotMatchPositions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SnapshotMatchPositions', createEmptyInstance: create)
    ..pc<MatchPositions>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'all', $pb.PbFieldType.PM, subBuilder: MatchPositions.create)
    ..hasRequiredFields = false
  ;

  SnapshotMatchPositions._() : super();
  factory SnapshotMatchPositions({
    $core.Iterable<MatchPositions>? all,
  }) {
    final _result = create();
    if (all != null) {
      _result.all.addAll(all);
    }
    return _result;
  }
  factory SnapshotMatchPositions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SnapshotMatchPositions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SnapshotMatchPositions clone() => SnapshotMatchPositions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SnapshotMatchPositions copyWith(void Function(SnapshotMatchPositions) updates) => super.copyWith((message) => updates(message as SnapshotMatchPositions)) as SnapshotMatchPositions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SnapshotMatchPositions create() => SnapshotMatchPositions._();
  SnapshotMatchPositions createEmptyInstance() => create();
  static $pb.PbList<SnapshotMatchPositions> createRepeated() => $pb.PbList<SnapshotMatchPositions>();
  @$core.pragma('dart2js:noInline')
  static SnapshotMatchPositions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SnapshotMatchPositions>(create);
  static SnapshotMatchPositions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<MatchPositions> get all => $_getList(0);
}

class MatchPositions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MatchPositions', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..pc<MatchPosition>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'all', $pb.PbFieldType.PM, subBuilder: MatchPosition.create)
    ..hasRequiredFields = false
  ;

  MatchPositions._() : super();
  factory MatchPositions({
    $core.String? name,
    $core.Iterable<MatchPosition>? all,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (all != null) {
      _result.all.addAll(all);
    }
    return _result;
  }
  factory MatchPositions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MatchPositions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MatchPositions clone() => MatchPositions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MatchPositions copyWith(void Function(MatchPositions) updates) => super.copyWith((message) => updates(message as MatchPositions)) as MatchPositions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MatchPositions create() => MatchPositions._();
  MatchPositions createEmptyInstance() => create();
  static $pb.PbList<MatchPositions> createRepeated() => $pb.PbList<MatchPositions>();
  @$core.pragma('dart2js:noInline')
  static MatchPositions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MatchPositions>(create);
  static MatchPositions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<MatchPosition> get all => $_getList(1);
}

class MatchPosition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MatchPosition', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leftRatio', $pb.PbFieldType.OD, protoName: 'leftRatio')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'topRatio', $pb.PbFieldType.OD, protoName: 'topRatio')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rightRatio', $pb.PbFieldType.OD, protoName: 'rightRatio')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bottomRatio', $pb.PbFieldType.OD, protoName: 'bottomRatio')
    ..hasRequiredFields = false
  ;

  MatchPosition._() : super();
  factory MatchPosition({
    $core.double? leftRatio,
    $core.double? topRatio,
    $core.double? rightRatio,
    $core.double? bottomRatio,
  }) {
    final _result = create();
    if (leftRatio != null) {
      _result.leftRatio = leftRatio;
    }
    if (topRatio != null) {
      _result.topRatio = topRatio;
    }
    if (rightRatio != null) {
      _result.rightRatio = rightRatio;
    }
    if (bottomRatio != null) {
      _result.bottomRatio = bottomRatio;
    }
    return _result;
  }
  factory MatchPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MatchPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MatchPosition clone() => MatchPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MatchPosition copyWith(void Function(MatchPosition) updates) => super.copyWith((message) => updates(message as MatchPosition)) as MatchPosition; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MatchPosition create() => MatchPosition._();
  MatchPosition createEmptyInstance() => create();
  static $pb.PbList<MatchPosition> createRepeated() => $pb.PbList<MatchPosition>();
  @$core.pragma('dart2js:noInline')
  static MatchPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MatchPosition>(create);
  static MatchPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get leftRatio => $_getN(0);
  @$pb.TagNumber(1)
  set leftRatio($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLeftRatio() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeftRatio() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get topRatio => $_getN(1);
  @$pb.TagNumber(2)
  set topRatio($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTopRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopRatio() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get rightRatio => $_getN(2);
  @$pb.TagNumber(3)
  set rightRatio($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRightRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearRightRatio() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get bottomRatio => $_getN(3);
  @$pb.TagNumber(4)
  set bottomRatio($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBottomRatio() => $_has(3);
  @$pb.TagNumber(4)
  void clearBottomRatio() => clearField(4);
}

