import 'package:dartz/dartz.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}