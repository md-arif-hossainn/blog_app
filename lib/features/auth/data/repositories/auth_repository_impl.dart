import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/domain/entities/user.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  // final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
    this.remoteDataSource,
    //    this.connectionChecker,
  );

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
        // final session = await remoteDataSource.currentUserSession;
        // if (session == null) {
        //   return left(Failure('User not logged in!'));
        // }
        //
        // return right(session);
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // try {
    //   final user = await remoteDataSource.signUpWithEmailPassword(
    //     name: name,
    //     email: email,
    //     password: password,
    //   );
    //   return right(user);
    // } on ServerException catch (e) {
    //   return left(Failure(e.message));
    // }

      return _getUser(
            () async => remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
        ),
      );
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    // try {
    //   final user = await remoteDataSource.loginWithEmailPassword(
    //       email: email, password: password);
    //   return right(user);
    // } on ServerException catch (e) {
    //   return left(Failure(e.message));
    // }

    return _getUser(
          () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }


  Future<Either<Failure, User>> _getUser(
      Future<User> Function() fn,
      ) async {
    try {
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

}
