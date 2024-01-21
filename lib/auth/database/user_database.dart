import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
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
          'CREATE TABLE $tableUser ($userId INTEGER PRIMARY KEY, $userName TEXT, $userAge INTEGER)');
    });
  }

  // Insert Data
  Future inserData(User? user) async {
    var db = await initDataBase();
    await db.insert(tableUser, user!.toMap());
  }

  //Update   Data
  Future updateData() async {}

  // Delete Data
  Future deleteData({required int deletUserId}) async {
    var db = await initDataBase();
    await db.delete(tableUser, where: '$userId=?', whereArgs: [deletUserId]);
  }

  //Get Data
  Future<List<User>> getData() async {
    var db = await initDataBase();
    List<Map<String, dynamic>> result = await db.query(tableUser);
    return result.map((e) => User.fromMap(e)).toList();
  }
}
