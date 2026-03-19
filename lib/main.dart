import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_auth/router.dart';
import 'injection_container.dart' as di;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    _authBloc = di.sl<AuthBloc>();
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Auth Clean App',
        routerConfig: _appRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF00BCD4),
          useMaterial3: true,
        ),
      ),
    );
  }
}