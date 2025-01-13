import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit(this._firebaseAuth) : super(AuthInitial());

  Future<void> registerUser(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
