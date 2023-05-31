import 'package:drift/drift.dart';

class Schedules extends Table {
  //PRIMARY KEY 오토인크리먼트하면 id를 입력할 필요가 없다
  IntColumn get id => integer().autoIncrement()();
  //내용
  TextColumn get content => text()();
  //일정 날짜
  DateTimeColumn get date => dateTime()();
  //시작시간
  IntColumn get startTime => integer()();
  //끝 시간
  IntColumn get endTime => integer()();

  //category color table id
  IntColumn get colorId => integer()();

  //생성날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
