import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userLoggedInKey = "LOGGEDIN";
  static String userIdKey = "USERID";

  // save data
  Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userLoggedInKey, isUserLoggedIn);
  }

  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey, userId);
  }

  // get data
  Future<bool> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
}
