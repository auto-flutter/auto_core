import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:auto_core/protos/app_info.pbserver.dart';
import 'package:auto_core/protos/http.pbserver.dart';
import 'package:auto_core/protos/script_meta_data.pbserver.dart';
import 'package:auto_core/src/auto_script.dart';
import 'package:logging/logging.dart';

import '../auto_core.dart';
import 'basic.dart';
import 'raw_playback_data.dart';
import 'tar_key.dart';
import 'tar_util.dart';

final Logger _log = Logger('RemoteDevice');

class RequestResult<R> {
  R? result;
  BadRequestResponse? error;

  bool get ok => result != null;

  RequestResult({this.result, this.error});
}

class RemoteApp {
  final String host;
  final int port;

  static final HttpClient _httpClient = HttpClient();

  RemoteApp({required this.host, required this.port});

  Future<RequestResult<AppInfo>> info() async {
    final request = await _httpClient.post(host, port, 'info');
    final response = await request.close();
    final body = await streamToIntList(response);

    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: AppInfo.fromBuffer(body));
    } else {
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<bool>> pause() async {
    final request = await _httpClient.post(host, port, 'pause');
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<bool>> continue1() async {
    final request = await _httpClient.post(host, port, 'continue');
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<bool>> addCheckpoint() async {
    final request = await _httpClient.post(host, port, 'addCheckpoint');
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<bool>> addDelay(Duration delay) async {
    Map<String, dynamic>? queryParameters = <String, dynamic>{};
    queryParameters["delay"] = delay.inMicroseconds.toString();
    Uri url = Uri(
        scheme: "http",
        host: host,
        port: port,
        path: 'addDelay',
        queryParameters: queryParameters);

    final request = await _httpClient.postUrl(url);
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<bool>> enterText(String text) async {
    final request = await _httpClient.post(host, port, 'enterText');
    request.add(utf8.encode(text));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<bool> ping() async {
    try {
      final request = await _httpClient.post(host, port, 'ping');
      final response = await request.close();
      return response.statusCode == HttpStatus.ok;
    } catch (e, s) {
      _log.severe('ping', e, s);
      return false;
    }
  }

  Future<RequestResult<bool>> start({bool force = false,bool disableKeyboard = false}) async {
    Map<String, dynamic>? queryParameters = <String, dynamic>{};
    if (force) {
      queryParameters["force"] = null;
    }
    if (disableKeyboard) {
      queryParameters["disableKeyboard"] = null;
    }
    Uri url = Uri(
        scheme: "http",
        host: host,
        port: port,
        path: 'start',
        queryParameters: queryParameters);

    final request = await _httpClient.postUrl(url);
    final response = await request.close();
    final body = await streamToIntList(response);
    if (response.statusCode != HttpStatus.ok) {
      throw BadRequestResponse.fromBuffer(body);
    }

    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<AutoScript>> stop(List<String> dependencies) async {
    final request = await _httpClient.post(host, port, 'stop');
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      final tarData =await streamToIntList(response);
      Archive archive = TarDecoder().decodeBytes(tarData);

      List<Checkpoint> checkpointList = [];
      late final List<int> record;
      late final ScriptMetaData scriptMetaData;

      Iterator<ArchiveFile> iterator=archive.iterator;
      while (iterator.moveNext()) {
        final contents = iterator.current.content as List<int>;
        if (iterator.current.name == TarKey.recordStream) {
          record = contents;
        } else if (iterator.current.name.startsWith(TarKey.screenshotPrefix)) {
          checkpointList.add(
              Checkpoint(name: iterator.current.name, snapshot: Uint8List.fromList(contents)));
        } else if (iterator.current.name == TarKey.scriptMetaData) {
          scriptMetaData = ScriptMetaData.fromBuffer(contents);
        }
      }
      return RequestResult(
          result: AutoScript(
              metaData: scriptMetaData,
              checkpoints: checkpointList,
              record: record,dependencies: dependencies));
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<RawPlaybackResult>> replay(List<int> recordStream,
      {bool force = false,
      Duration? timeout,
      List<List<int>>? dependencies}) async {
    Map<String, dynamic>? queryParameters = <String, dynamic>{};
    if (force) {
      queryParameters["force"] = null;
    }
    Uri url = Uri(
        scheme: "http",
        host: host,
        port: port,
        path: 'replay',
        queryParameters: queryParameters);
    final request = await _httpClient.postUrl(url);

    final tarEncoder = TarEncoder();
    OutputStream stream= OutputStream();
    tarEncoder.start(stream);
    tarEncoder.add(ArchiveFile(TarKey.replayData, recordStream.length, recordStream));

    if (dependencies != null) {
      for (int i = 0; i < dependencies.length; i++) {
        tarEncoder.add(ArchiveFile('${TarKey.dependencyPrefix}$i', dependencies[i].length, dependencies[i]));
      }
    }
    tarEncoder.finish();

    request.add(stream.getBytes());

    Future<HttpClientResponse> responseFuture = request.close();
    if (timeout != null) {
      Timer(timeout, () {
          request.abort();
      });
    }
    final response = await responseFuture;

    if (response.statusCode == HttpStatus.ok) {
      final tarData =await streamToIntList(response);
      Archive archive = TarDecoder().decodeBytes(tarData);


      final Map<String, Uint8List> snapshots = <String, Uint8List>{};
      List<int>? log;
      AppInfo appInfo = AppInfo();
      final iterator = archive.iterator;
      while (iterator.moveNext()) {
        final contents = iterator.current.content as List<int>;
        if (iterator.current.name.startsWith(TarKey.screenshotPrefix)) {
          snapshots[iterator.current.name] = Uint8List.fromList(contents);
        } else if (iterator.current.name == TarKey.log) {
          log = contents;
        }else if (iterator.current.name == TarKey.appInfo) {
          appInfo = AppInfo.fromBuffer(contents);
        }
      }
      return RequestResult(
          result: RawPlaybackResult(log: log, snapshots: snapshots,appInfo: appInfo));
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }

  Future<RequestResult<RawPlaybackResult>> replayWithTarFile(String path,
      { bool force = false, Duration? timeout}) async {
    final data = await TarUtil.getRecordStreamWithTarPath(path);
    final dependencies = await TarUtil.resolveDependencies(path);

    return replay(data,
        force: force,
        dependencies: dependencies,
        timeout: timeout);
  }

  Future<RequestResult<bool>> stopReplay() async {
    final request = await _httpClient.post(host, port, 'stopReplay');
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return RequestResult(result: true);
    } else {
      final body = await streamToIntList(response);
      return RequestResult(error: BadRequestResponse.fromBuffer(body));
    }
  }
}
