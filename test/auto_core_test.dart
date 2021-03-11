import 'dart:io';

import 'package:auto_core/src/tar_util.dart';
import 'package:test/test.dart';

void main() {
  test('depthFirstTraverse', () async {
    final dependencies = <String, List<String>>{};
    dependencies['1'] = ['2', '3'];
    dependencies['2'] = ['4'];
    dependencies['3'] = ['4'];
    dependencies['4'] = [];
    expect(depthFirstTraverse(dependencies, '1'), ['2', '4', '3', '4']);
  });
  test('depthFirstTraverse', () async {
    final dependencies = <String, List<String>>{};
    dependencies['1'] = [];
    expect(depthFirstTraverse(dependencies, '1'), []);
  });
  test('depthFirstTraverse exception', () async {
    final dependencies = <String, List<String>>{};
    dependencies['1'] = ['2', '3'];
    dependencies['2'] = ['4'];
    dependencies['3'] = ['4'];
    dependencies['4'] = ['1'];
    expect(() => depthFirstTraverse(dependencies, '1'), throwsException);
  });
}
