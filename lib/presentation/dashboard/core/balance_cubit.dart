import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/core/entity/transaction.dart';
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

  Future<void> addMoney(double amount, BuildContext context) async {
    emit(BalanceAddMoneyLoading());
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
        final transactionId = firestore.collection('transactions').doc().id;

        final transaction = TransactionModel(
          uid: uid,
          money: amount,
          type: 'charge',
          recipient: '',
          sender: uid,
          date: Timestamp.now(),
          transactionId: transactionId,
        );
        await addTransaction(transaction);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Mamo Pay'),
                content: const Text('100 AED has been added'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    },
                  ),
                ],
              );
            },
          );
        });
        emit(BalanceLoaded(user));
      } else {
        emit(BalanceFailure('User data not found'));
      }
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await firestore
          .collection('transactions')
          .doc(transaction.transactionId)
          .set(transaction.toFirestore());
    } catch (e) {}
  }
}
