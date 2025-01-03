import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({
    required UserSignUp userSignUp
}) : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
  }

  void _onAuthSignUp(
      AuthSignUp event,
      Emitter<AuthState> emit,
      ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (uid) => emit(AuthSuccess(uid)),
    );
  }
}
