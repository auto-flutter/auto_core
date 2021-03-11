///
//  Generated code. Do not modify.
//  source: dependencies.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Dependencies extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Dependencies', createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dependencies')
    ..hasRequiredFields = false
  ;

  Dependencies._() : super();
  factory Dependencies({
    $core.Iterable<$core.String>? dependencies,
  }) {
    final _result = create();
    if (dependencies != null) {
      _result.dependencies.addAll(dependencies);
    }
    return _result;
  }
  factory Dependencies.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Dependencies.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Dependencies clone() => Dependencies()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Dependencies copyWith(void Function(Dependencies) updates) => super.copyWith((message) => updates(message as Dependencies)) as Dependencies; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Dependencies create() => Dependencies._();
  Dependencies createEmptyInstance() => create();
  static $pb.PbList<Dependencies> createRepeated() => $pb.PbList<Dependencies>();
  @$core.pragma('dart2js:noInline')
  static Dependencies getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dependencies>(create);
  static Dependencies? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get dependencies => $_getList(0);
}

