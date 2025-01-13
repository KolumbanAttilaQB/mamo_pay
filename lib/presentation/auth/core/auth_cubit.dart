import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthCubit(this._firebaseAuth, this._firestore) : super(AuthInitial());

  Future<void> registerUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': email,
        'email': email,
        'money': 0.0,
        'last_transfer_date': null,
        'created_at': FieldValue.serverTimestamp(),
        'last_login': FieldValue.serverTimestamp()
      });

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user != null) {
        final uid = user.user!.uid;
        await _firestore.collection('users').doc(uid).update({
          'last_login': FieldValue.serverTimestamp(),
        });
      }

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
