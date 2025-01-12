

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/common/cubits/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/blog/data/datasources/blog_remote_data_source.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repository.dart';
import 'features/blog/domain/usecase/uoload_blog.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';

final serviceLocator = GetIt.instance;


Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(
        () => AppUserCubit(),
  );

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
        appUserCubit:serviceLocator(),
      ),
    );

}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // ..registerFactory<BlogLocalDataSource>(
    //       () => BlogLocalDataSourceImpl(
    //     serviceLocator(),
    //   ),
    // )
  // Repository
    ..registerFactory<BlogRepository>(
          () => BlogRepositoryImpl(
        serviceLocator(),
      ),
    )
  // Usecases
    ..registerFactory(
          () => UploadBlog(
        serviceLocator(),
      ),
    )
    // ..registerFactory(
    //       () => GetAllBlogs(
    //     serviceLocator(),
    //   ),
    // )
  // Bloc
    ..registerLazySingleton(
          () => BlogBloc(
              uploadBlog: serviceLocator()
          ),
    );
}