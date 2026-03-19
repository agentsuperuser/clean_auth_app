import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/core/usecases/usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';

class LogoutUsecase implements Usecase<void, NoParams> {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
  
}