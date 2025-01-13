import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/core/entity/user_model.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BalanceCubit(this.firestore, this.auth) : super(BalanceInitial());

  Future<void> fetchUserData() async {
    emit(BalanceLoading());
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        emit(BalanceFailure('User not logged in'));
        return;
      }

      final userDoc = await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final user = UserModel.fromFirestore(userDoc);
        emit(BalanceLoaded(user));
      } else {
        emit(BalanceFailure('User data not found'));
      }
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }

  Future<void> addMoney(double amount) async {
    emit(BalanceLoading());
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        emit(BalanceFailure('User not logged in'));
        return;
      }

      final userDoc = await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final user = UserModel.fromFirestore(userDoc);
        user.money += amount;
        await firestore.collection('users').doc(uid).update(user.toFirestore());
        emit(BalanceLoaded(user));
      } else {
        emit(BalanceFailure('User data not found'));
      }
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }

}
