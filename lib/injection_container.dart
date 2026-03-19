import 'package:flutter_clean_auth/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_auth/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_auth/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_clean_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future init() async {
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      logoutUsecase: sl(),
      getCurrentUserUsecase: sl(),
      checkAuthUsecase: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthUsecase(repository: sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl())
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPreferences
  );
}
