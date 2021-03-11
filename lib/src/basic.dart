import 'dart:io';
import 'package:path/path.dart' ;


const int Ok = 0;
const int Fail = -101;
const int Error = -102;

const String mainCmd = 'auto_util';


File createTempFile(String fileName){
  final dir = Directory.systemTemp;
  File file = File(join(dir.path,fileName));
  return file;
}

Future<List<int>> streamToIntList(Stream<List<int>> stream) async {
  return await stream.fold<List<int>>(<int>[],
          (List<int> previous, List<int> element) {
        previous.addAll(element);
        return previous;
      });
}