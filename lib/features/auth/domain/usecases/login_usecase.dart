import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/core/usecases/usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase implements Usecase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await repository.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}