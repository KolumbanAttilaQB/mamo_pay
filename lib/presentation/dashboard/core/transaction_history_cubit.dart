import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/core/entity/transaction.dart';
import 'transaction_history_state.dart';

class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TransactionHistoryCubit(this.firestore, this.auth) : super(TransactionHistoryInitial());

  Future<void> fetchTransactionHistory() async {
    emit(TransactionHistoryLoading());
    try {
      final uid = auth.currentUser?.uid;

      final querySnapshot = await firestore
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .get();

      final transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      emit(TransactionHistoryLoaded(transactions));
    } catch (e) {
      emit(TransactionHistoryFailure(e.toString()));
    }
  }
}
