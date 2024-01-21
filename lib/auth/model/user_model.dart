import 'package:flutter/foundation.dart';
import 'package:storage/auth/database/database_type.dart';

class User extends DataBaseType {
  int? id;
  String? name;
  int? age;
  User({this.id, this.name, this.age});
  Map<String, dynamic> toMap() {
    return {
      userId: id,
      userName: name,
      userAge: age,
    };
  }

  User.fromMap(Map<String, dynamic> data) {
    id = data[userId];
    name = data[userName];
    age = data[userAge];
  }
}
