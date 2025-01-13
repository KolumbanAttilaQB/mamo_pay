part of 'balance_cubit.dart';

sealed class BalanceState {}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState {
  final UserModel userData;

  BalanceLoaded(this.userData);
}

class BalanceFailure extends BalanceState {
  final String error;

  BalanceFailure(this.error);
}
