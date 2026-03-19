import 'dart:convert';

import 'package:flutter_clean_auth/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCatchedToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCatchedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedToken = 'cached_token';
  static const String cachedUser = 'cached_user';

  AuthLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(cachedToken, token);
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(cachedUser, json.encode(user.toJson()));
  }
  
  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(cachedToken);
    await sharedPreferences.remove(cachedUser);
  }
  
  @override
  Future<String?> getCatchedToken() async {
    return sharedPreferences.getString(cachedToken);
  }
  
  @override
  Future<UserModel?> getCatchedUser() async {
    final jsonString = sharedPreferences.getString(cachedUser);
    if(jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}