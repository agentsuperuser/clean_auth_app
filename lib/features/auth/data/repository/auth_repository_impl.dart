import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/exceptions.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_auth/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_auth/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource, required this.authLocalDataSource});

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await authLocalDataSource.getCatchedUser();
      return Right(user);
    } catch (err) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticatged() async {
    try {
      final token = await authLocalDataSource.getCatchedToken();
      return Right(token != null);
    } catch (err) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    try {
      final user = await authRemoteDataSource.login(email, password);
      await authLocalDataSource.cacheToken('mock_token_${user.id}');
      await authLocalDataSource.cacheUser(user);
      return Right(user);
    } on InvalidCredentialsFailure {
      return Left(InvalidCredentialsFailure());
    } on ServerException {
      return left(ServerFailure());
    } catch (err) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDataSource.logout();
      await authLocalDataSource.clearToken();
      return Right(null);
    } catch (err) {
      return Left(ServerFailure());
    }
  }
}