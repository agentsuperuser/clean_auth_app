import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_clean_auth/features/auth/presentation/pages/home_page.dart';
import 'package:flutter_clean_auth/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_clean_auth/features/auth/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSplash = state.matchedLocation == '/splash';

      if(authState is AuthUnauthenticated || authState is AuthError) {
        return isGoingToLogin ? null : '/login';
      }
      if(authState is AuthAuthenticated) {
        if(isGoingToLogin || isGoingToSplash) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) {
        return SplashPage();
      },),

      GoRoute(path: '/login', builder: (context, state) {
        return LoginPage();
      },),

      GoRoute(path: '/home', builder: (context, state) {
        return HomePage();
      },)
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription subscription;
}
