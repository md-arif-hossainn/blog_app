

import 'package:blog_app/features/auth/data/usecases/current_user.dart';
import 'package:blog_app/features/auth/data/usecases/user_login.dart';
import 'package:blog_app/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';
import 'domain/repository/auth_repository.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/usecases/user_sign_up.dart';

final serviceLocator = GetIt.instance;


Future<void> initDependencies() async {
  _initAuth();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )

  // Repository
  ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )

  // Usecases
  ..registerFactory(
          () => UserSignUp(
        serviceLocator(),
      ),
    )

  ..registerFactory(
        () => UserLogin(
      serviceLocator(),
    ),
  )
    ..registerFactory(
          () => CurrentUser(
        serviceLocator(),
      ),
    )

  // Bloc
 ..registerLazySingleton(
          () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
      ),
    );

}