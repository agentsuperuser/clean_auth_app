import 'package:flutter_clean_auth/core/error/exceptions.dart';
import 'package:flutter_clean_auth/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));

    if(email == 'akash@turvaldx.com' && password == 'akash@2001') {
      return UserModel(id: '1', email: 'akash@turvaldx.com', name: 'Akash S');
    } else {
      throw InvalidCredentialsException();
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
  }

}