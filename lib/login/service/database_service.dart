import 'package:expense_logo/login/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../deshbord/model/money_record_model.dart';


class DatabaseService {
  late Database database;
  String userTableName = 'user';
  String moneyRecordTableName = 'money_record';


  Future<void> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'money_tracker.db');
    database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      createUserTable(db);
      createtransactionTable(db);
    });
  }

  Future<void> createtransactionTable(Database db) async {
    await db.execute(
        'create table $moneyRecordTableName(id integer primary key autoincrement , '
        'title text, amount real,category text,date integer, type text   )');
  }

  Future<void> createUserTable(Database db) async {
    await db.execute(
        'CREATE TABLE $userTableName (email TEXT PRIMARY KEY, name TEXT, password TEXT)');
  }

  Future<void> registerUser(User user) async {
    await database.rawInsert(
        'INSERT INTO $userTableName (email, name, password) VALUES (?, ?, ?)',
        [user.email, user.name, user.password]);
    print('User added successfully');
  }

  Future<bool> isUserExists(User user) async {
    List<Map<String, dynamic>> list = await database.rawQuery(
        "SELECT * FROM $userTableName WHERE email = ? AND password = ?",
        [user.email, user.password]);
    return list.isNotEmpty;
  }

  // Future<void> insertStudent(MoneyRecordModel student) async {
  //   await database.rawInsert(
  //      'INSERT INTO $studentTableName (title, amount, category) VALUES (?, ?, ?)',
  //     [student.title, student.amount, student.category],
  //        );
  // }


  // Future<List<MoneyRecordModel>> getAllStudents() async {
  //    List<Map<String, dynamic>> mapList =
  //   await database.rawQuery('SELECT * FROM $studentTableName');
  //   List<MoneyRecordModel> studentModelList = [];
  //   for (int i = 0; i < mapList.length; i++) {
  //      Map<String, dynamic> map = mapList[i];
  //     MoneyRecordModel studentModel = MoneyRecordModel.fromJson(map);
  //          studentModelList.add(studentModel);
  //   }
  //     return studentModelList;
  // }




  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    await database.rawInsert(
        'INSERT INTO $moneyRecordTableName (title,amount,category,date,type)values(?,?,?,?,?)',
        [
          moneyRecord.title,
          moneyRecord.amount,
          moneyRecord.category,
          moneyRecord.date,
          moneyRecord.type.toString()
        ]);
    print('Money Record added successfully');
  }

  Future editMoneyRecord(MoneyRecord moneyRecord) async {
    await database.rawUpdate(
        'update  $moneyRecordTableName (title=?,'
        'amount=?,'
        'category=?,'
        'date=?,type=?'
        'Where id =? ,',
        [
          moneyRecord.title,
          moneyRecord.amount,
          moneyRecord.category,
          moneyRecord.date,
          moneyRecord.type.toString()
        ]);
    print('Money Record update  successfully');
  }

  Future<List<MoneyRecord>> getMoneyRecord() async {
    List<Map<String, dynamic>> records =
        await database.rawQuery('Select*from $moneyRecordTableName');
    List<MoneyRecord> moneyRecordList = [];
    for (int i = 0; i < records.length; i++) {
      Map<String, dynamic> map = records[i];
      MoneyRecord moneyRecord = MoneyRecord.fromJson(map);
      moneyRecordList.add(moneyRecord);
    }
    return moneyRecordList;
  }

  Future deleteMoneyRecord(int id) async {
    await database.rawInsert(
      'delete from $moneyRecordTableName where id =?',
      [id],
    );
    print('Money Record delete successfully');
  }
}
