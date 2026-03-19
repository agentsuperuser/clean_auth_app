import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isAuthenticatged();  
}