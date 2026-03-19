import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/core/usecases/usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUsecase implements Usecase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}