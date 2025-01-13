import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String uid;
  double money;
  String type;
  String recipient;
  String sender;
  Timestamp date;
  String transactionId;

  TransactionModel({
    required this.uid,
    required this.money,
    required this.type,
    required this.recipient,
    required this.sender,
    required this.date,
    required this.transactionId,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      uid: data['uid'] ?? '',
      money: data['money']?.toDouble() ?? 0.0,
      type: data['type'] ?? '',
      recipient: data['recipient'] ?? '',
      sender: data['sender'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      transactionId: data['transaction_id'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'money': money,
      'type': type,
      'recipient': recipient,
      'sender': sender,
      'date': date,
      'transaction_id': transactionId,
    };
  }
}
