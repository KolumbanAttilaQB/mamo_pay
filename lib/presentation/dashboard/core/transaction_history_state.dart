import 'package:mamopay_clone/core/entity/transaction.dart';

sealed class TransactionHistoryState {
  const TransactionHistoryState();

  @override
  List<Object> get props => [];
}

class TransactionHistoryInitial extends TransactionHistoryState {}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionModel> transactions;

  const TransactionHistoryLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionHistoryFailure extends TransactionHistoryState {
  final String error;

  const TransactionHistoryFailure(this.error);

  @override
  List<Object> get props => [error];
}
