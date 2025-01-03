import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
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

  // @override
  // Future<Either<Failure, User>> currentUser() async {
  //   try {
  //     if (!await (connectionChecker.isConnected)) {
  //       final session = remoteDataSource.currentUserSession;
  //
  //       if (session == null) {
  //         return left(Failure('User not logged in!'));
  //       }
  //
  //       return right(
  //         UserModel(
  //           id: session.user.id,
  //           email: session.user.email ?? '',
  //           name: '',
  //         ),
  //       );
  //     }
  //     final user = await remoteDataSource.getCurrentUserData();
  //     if (user == null) {
  //       return left(Failure('User not logged in!'));
  //     }
  //
  //     return right(user);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }



  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // return _getUser(
    //       () async => await remoteDataSource.signUpWithEmailPassword(
    //     name: name,
    //     email: email,
    //     password: password,
    //   ),
    // );
    
    try{
    final userId =  await remoteDataSource.signUpWithEmailPassword(
          name: name,
          email: email,
          password: password,
        );
    return right(userId);
    } on ServerException catch (e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> loginWithEmailPassword({required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }
  //
  // Future<Either<Failure, User>> _getUser(
  //     Future<User> Function() fn,
  //     ) async {
  //   try {
  //     if (!await (connectionChecker.isConnected)) {
  //       return left(Failure(Constants.noConnectionErrorMessage));
  //     }
  //     final user = await fn();
  //
  //     return right(user);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }
}