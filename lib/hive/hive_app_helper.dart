import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:my_meal_app/hive/user.dart';

class HiveAppHelper {
  static const keyUser = "user_id";
  static const hiveBoxName = "hive_box";

  Future<bool> register(User user) async{
    try{
      final box = await Hive.openBox(hiveBoxName);
      await box.put(user.email,user);
      return true;
    }catch (e){
      return false;
    }
  }

  Future<bool> checkUser(String email) async{
    try{
      final box = await Hive.openBox(hiveBoxName);
      User? user = box.get(email);
      return user != null;
    }catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async{
    try{
      final box = await Hive.openBox(hiveBoxName);
      User? user = box.get(email);
      bool isLogedIn = user?.email == email && user?.password == password;
      if (isLogedIn){
        String encodedCredentials = base64Encode(utf8.encode("$email:$password"));
        updateUser(user, encodedCredentials);
      }
      return isLogedIn;
    }catch (e) {
      return false;
    }
  }

  Future<void> updateUser(User? user, String credentials) async {
    try {
      final box = await Hive.openBox(hiveBoxName);
      User newData = User(
          name: user?.name ?? "",
          email: user?.email ?? "",
          password: user?.password ?? "",
          credential:credentials
      );
      box.put(user?.email, newData);
    }catch(e){
      if (kDebugMode) print("error $e");
    }
  }

  Future<bool> isLogedIn() async {
    try {
      final box = await Hive.openBox(hiveBoxName);

      bool anyUserHaveCredentials = false;

      final allData = box.values.toList();
      for (var data in allData) {
        if (data is User && data.credential.isNotEmpty) {
          anyUserHaveCredentials = true;
          break;
        }
      }
      await box.close();
      return anyUserHaveCredentials;
    }catch(e){
      if (kDebugMode) print("error $e");
      return false;
    }
  }

  Future<bool> logout() async{
    try {
      final box = await Hive.openBox(hiveBoxName);
      final allData = box.values.toList();
      for (var data in allData) {
        if (data is User && data.credential.isNotEmpty) {
          updateUser(data, "");
        }
      }
      return true;
    }catch(e){
      if (kDebugMode) print("error $e");
      return false;
    }
  }
}