import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/core/entity/user_model.dart';
import 'package:mamopay_clone/core/entity/transaction.dart';
import 'send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  SendMoneyCubit(this.firestore, this.auth) : super(SendMoneyInitial());

  Future<void> sendMoney(double amount, String recipientUid) async {
    emit(SendMoneyLoading());
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        emit(const SendMoneyFailure('User not logged in'));
        return;
      }

      final userDoc = await firestore.collection('users').doc(uid).get();
      final recipientDoc = await firestore.collection('users').doc(recipientUid).get();

      if (userDoc.exists && recipientDoc.exists) {
        final user = UserModel.fromFirestore(userDoc);
        final recipient = UserModel.fromFirestore(recipientDoc);

        if (user.money >= amount) {
          user.money -= amount;
          recipient.money += amount;

          final transactionId = firestore.collection('transactions').doc().id;

          final transaction = TransactionModel(
            uid: uid,
            money: amount,
            type: 'send',
            recipient: recipientUid,
            sender: uid,
            date: Timestamp.now(),
            transactionId: transactionId,
          );


          await firestore.collection('users').doc(uid).update({
            'money': user.money,
            'last_transfer_date': Timestamp.now()
          });

          await firestore.collection('users').doc(recipientUid).update({
            'money': recipient.money,
            'last_transfer_date': Timestamp.now()
          });
          await addTransaction(transaction);

          emit(SendMoneySuccess(user.money));
        } else {
          emit(const SendMoneyFailure('Insufficient balance'));
        }
      } else {
        emit(const SendMoneyFailure('User or recipient data not found'));
      }
    } catch (e) {
      emit(SendMoneyFailure(e.toString()));
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await firestore
          .collection('transactions')
          .doc(transaction.transactionId)
          .set(transaction.toFirestore());
    } catch (e) {
      emit(SendMoneyFailure(e.toString()));
    }
  }


}
