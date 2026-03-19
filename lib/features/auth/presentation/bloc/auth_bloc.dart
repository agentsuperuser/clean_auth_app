import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_auth/core/error/failures.dart';
import 'package:flutter_clean_auth/core/usecases/usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_clean_auth/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final CheckAuthUsecase checkAuthUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.checkAuthUsecase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await checkAuthUsecase(NoParams());

    // ✅ Use fold only for the decision, no async inside
    final isAuthenticated = result.fold((left) => false, (right) => right);

    if (!isAuthenticated) {
      emit(AuthUnauthenticated());
      return;
    }

    final userResult = await getCurrentUserUsecase(NoParams());
    userResult.fold((left) => emit(AuthUnauthenticated()), (right) {
      if (right != null) {
        emit(AuthAuthenticated(userEntity: right));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (l) {
        String message = 'Auth Error';
        if (l is InvalidCredentialsFailure) {
          message = 'Wrong email or password!';
        } else if (l is ServerFailure) {
          message = 'Server failure!';
        }
        emit(AuthError(message: message));
      },
      (r) {
        emit(AuthAuthenticated(userEntity: r));
      },
    );
  }

  Future _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUsecase(NoParams());

    result.fold(
      (l) {
        emit(AuthError(message: 'Logout Error'));
      },
      (r) {
        emit(AuthUnauthenticated());
      },
    );
  }
}
