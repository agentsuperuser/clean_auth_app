import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/core/usecases/usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';

class CheckAuthUsecase implements Usecase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticatged();
  }

}