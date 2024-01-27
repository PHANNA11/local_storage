// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:storage/auth/database/database_type.dart';
import 'package:storage/auth/model/user_model.dart';

class UserDataBase extends DataBaseType {
  Future<Database> initDataBase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demoUser.db');

// Delete the database
    // await deleteDatabase(path);
// open the database
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE $tableUser ($userId INTEGER PRIMARY KEY AUTOINCREMENT, $userName TEXT, $userAge INTEGER,$createDate TEXT NOT NULL)');
    });
  }

  // Insert Data
  Future inserData(User? user) async {
    var db = await initDataBase();
    await db.insert(tableUser, user!.toMap());
  }

  //Update   Data
  Future updateData(User? user) async {
    var db = await initDataBase();
    await db.update(tableUser, user!.toMap(),
        where: '$userId=?', whereArgs: [user.id]);
  }

  // Delete Data
  Future deleteData({required int deletUserId}) async {
    var db = await initDataBase();
    await db.delete(tableUser, where: '$userId=?', whereArgs: [deletUserId]);
  }

  //Get Data
  Future<List<User>> getData({int limit = 10, int offset = 0}) async {
    var db = await initDataBase();
    List<Map<String, dynamic>> result =
        await db.query(tableUser, limit: 10, offset: offset);
    return result.map((e) => User.fromMap(e)).toList();
  }
}
