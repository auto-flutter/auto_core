import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:auto_core/protos/dependencies.pbserver.dart';
import 'package:path/path.dart' as pathHelper;

import 'tar_key.dart';

class TarUtil {
  static Future<List<List<int>>> resolveDependencies(
      String path) async {

    assert(pathHelper.isAbsolute(path));

    return await IOOverrides.runZoned(() async {
      final rootPath = pathHelper.dirname(path);
      IOOverrides.current!.setCurrentDirectory(rootPath);

      Map<String, List<String>> dependencies = <String, List<String>>{};
      await _readAllDependencyKey(path, dependencies);
      List<String> finalDependencies = depthFirstTraverse(dependencies, path);
      List<List<int>> result = <List<int>>[];

      for (String d in finalDependencies) {
        assert(pathHelper.isRelative(d));

        File file = File(d);
        if (!file.existsSync()) {
          throw Exception('${file.path} does not exist');
        }
        List<int> data =
        await _getStreamWithTarData(File(d), TarKey.recordStream);

        result.add(data);
      }
      return result;
    });
  }

  static Future<void> _readAllDependencyKey(
      String path, Map<String, List<String>> result) async {
    if (result.containsKey(path)) {
      return;
    }
    File file = File(path);
    if (!file.existsSync()) {
      throw Exception('${file.path} does not exist');
    }
    final bytes =
        await _getStreamWithTarData(file, TarKey.allDependency);

    final dependencies = Dependencies.fromBuffer(bytes);
    result[path] = dependencies.dependencies;

    for (String d in dependencies.dependencies) {
      await _readAllDependencyKey(d, result);
    }
  }

  static Future<List<int>> getRecordStreamWithTarPath(
      String tarPath) async {
    File file = File(tarPath);
    if (!file.existsSync()) {
      throw Exception('${file.path} does not exist');
    }
    return getRecordStreamWithTarData(file);
  }

  static Future<List<int>> getRecordStreamWithTarData(
      File tar) async {
    return _getStreamWithTarData(tar, TarKey.recordStream);
  }

  static Future<List<int>> getLogStreamWithTarData(
      File tar) async {
    return _getStreamWithTarData(tar, TarKey.log);
  }

  static Future<List<int>> _getStreamWithTarData(
      File tar, String name) async {
    final reader = TarDecoder().decodeBuffer(InputFileStream.file(tar));

    final data = reader.findFile(name);
    if(data!=null){
      return  data.content as List<int>;
    }else{
      return <int>[];
    }
  }
}

class _Dependency {
  final String key;
  int index = 0;

  _Dependency(this.key);

  @override
  String toString() {
    return key;
  }
}

List<String> depthFirstTraverse(
    Map<String, List<String>> dependencies, String root) {
  List<String> result = <String>[];
  List<_Dependency> stack = <_Dependency>[];
  Set<String> set = <String>{};

  stack.add(_Dependency(root));
  set.add(root);

  while (stack.isNotEmpty) {
    final last = stack.last;
    String? key;
    if (last.index < dependencies[last.key]!.length) {
      key = dependencies[last.key]![last.index];
    }
    if (key == null) {
      final removeItem = stack.removeLast();
      set.remove(removeItem.key);
      if (stack.isNotEmpty) {
        stack.last.index++;
      }
    } else {
      if (set.contains(key)) {
        String error = stack.skipWhile((value) => value.key != key).join('->');
        throw Exception('Circular dependency: $error->$key');
      }
      result.add(key);
      set.add(key);
      stack.add(_Dependency(key));
    }
  }

  return result;
}
