///
//  Generated code. Do not modify.
//  source: app_info.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use platformDescriptor instead')
const Platform$json = const {
  '1': 'Platform',
  '2': const [
    const {'1': 'unknown', '2': 0},
    const {'1': 'android', '2': 1},
    const {'1': 'ios', '2': 2},
    const {'1': 'windows', '2': 3},
    const {'1': 'macos', '2': 4},
    const {'1': 'linux', '2': 5},
    const {'1': 'web', '2': 6},
  ],
};

/// Descriptor for `Platform`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List platformDescriptor = $convert.base64Decode('CghQbGF0Zm9ybRILCgd1bmtub3duEAASCwoHYW5kcm9pZBABEgcKA2lvcxACEgsKB3dpbmRvd3MQAxIJCgVtYWNvcxAEEgkKBWxpbnV4EAUSBwoDd2ViEAY=');
@$core.Deprecated('Use modeDescriptor instead')
const Mode$json = const {
  '1': 'Mode',
  '2': const [
    const {'1': 'undefined', '2': 0},
    const {'1': 'debug', '2': 1},
    const {'1': 'profile', '2': 2},
    const {'1': 'release', '2': 3},
  ],
};

/// Descriptor for `Mode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modeDescriptor = $convert.base64Decode('CgRNb2RlEg0KCXVuZGVmaW5lZBAAEgkKBWRlYnVnEAESCwoHcHJvZmlsZRACEgsKB3JlbGVhc2UQAw==');
@$core.Deprecated('Use appInfoDescriptor instead')
const AppInfo$json = const {
  '1': 'AppInfo',
  '2': const [
    const {'1': 'platform', '3': 1, '4': 1, '5': 14, '6': '.Platform', '10': 'platform'},
    const {'1': 'mode', '3': 2, '4': 1, '5': 14, '6': '.Mode', '10': 'mode'},
    const {'1': 'deviceName', '3': 3, '4': 1, '5': 9, '10': 'deviceName'},
    const {'1': 'autoApiVersion', '3': 4, '4': 1, '5': 5, '10': 'autoApiVersion'},
    const {'1': 'devicePixelRatio', '3': 6, '4': 1, '5': 1, '10': 'devicePixelRatio'},
    const {'1': 'textScaleFactor', '3': 7, '4': 1, '5': 1, '10': 'textScaleFactor'},
    const {'1': 'physicalHeight', '3': 8, '4': 1, '5': 1, '10': 'physicalHeight'},
    const {'1': 'physicalWidth', '3': 9, '4': 1, '5': 1, '10': 'physicalWidth'},
  ],
};

/// Descriptor for `AppInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appInfoDescriptor = $convert.base64Decode('CgdBcHBJbmZvEiUKCHBsYXRmb3JtGAEgASgOMgkuUGxhdGZvcm1SCHBsYXRmb3JtEhkKBG1vZGUYAiABKA4yBS5Nb2RlUgRtb2RlEh4KCmRldmljZU5hbWUYAyABKAlSCmRldmljZU5hbWUSJgoOYXV0b0FwaVZlcnNpb24YBCABKAVSDmF1dG9BcGlWZXJzaW9uEioKEGRldmljZVBpeGVsUmF0aW8YBiABKAFSEGRldmljZVBpeGVsUmF0aW8SKAoPdGV4dFNjYWxlRmFjdG9yGAcgASgBUg90ZXh0U2NhbGVGYWN0b3ISJgoOcGh5c2ljYWxIZWlnaHQYCCABKAFSDnBoeXNpY2FsSGVpZ2h0EiQKDXBoeXNpY2FsV2lkdGgYCSABKAFSDXBoeXNpY2FsV2lkdGg=');
