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

  // schedules테이블안에 데이터를 넣을거다(row를 만들거다)
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  //모든색을 가져올것이기 때문에 파라미터는 따로 받지 않는다
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  //생성한 데이터베이스 테이블의 버전
  //데이터베이스의 구조가 바뀔때마다 버전을 올려줘야한다
  @override
  int get schemaVersion => 1;
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
