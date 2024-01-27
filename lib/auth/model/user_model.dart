import 'package:flutter/foundation.dart';
import 'package:storage/auth/database/database_type.dart';

class User extends DataBaseType {
  int? id;
  String? name;
  int? age;
  String? createAt;
  User({this.id, this.name, this.age, this.createAt});
  Map<String, dynamic> toMap() {
    return {userId: id, userName: name, userAge: age, createDate: createAt};
  }

  User.fromMap(Map<String, dynamic> data) {
    id = data[userId];
    name = data[userName];
    age = data[userAge];
    createAt = data[createDate];
  }
}
