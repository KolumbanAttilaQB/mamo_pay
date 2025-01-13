sealed class SendMoneyState {
  const SendMoneyState();

  @override
  List<Object> get props => [];
}

class SendMoneyInitial extends SendMoneyState {}

class SendMoneyLoading extends SendMoneyState {}

class SendMoneySuccess extends SendMoneyState {
  final double balance;

  const SendMoneySuccess(this.balance);

  @override
  List<Object> get props => [balance];
}

class SendMoneyFailure extends SendMoneyState {
  final String error;

  const SendMoneyFailure(this.error);

  @override
  List<Object> get props => [error];
}
