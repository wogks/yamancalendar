import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videocall2/model/category_color.dart';
import 'package:videocall2/model/schedule.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

@DriftDatabase(tables: [
  Schedules,
  CategoryColors,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
}

LazyDatabase _openConnection() {
  //데이터베이스 파일을 어던 위치에 저장시킬건지
  return LazyDatabase(() async {
    //데이터를 저장할수있는(배정받은) 폴더의 위치를 가져올수있다
    final dbFolder = await getApplicationDocumentsDirectory();
    //데이터베이스 위치 경로 정보를 가져오고 그 경로에 db.sqlite라는 파일을 생성하고 file이라는 곳에 저장한다
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    //file로 데이터베이스를 만든다
    return NativeDatabase(file);
  });
}
