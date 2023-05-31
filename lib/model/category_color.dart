import 'package:drift/drift.dart';

class CategoryColors extends Table {
  //PRIMARY Key
  IntColumn get id => integer().autoIncrement()();
  //색상코드
  TextColumn get hexCode => text()();
}
