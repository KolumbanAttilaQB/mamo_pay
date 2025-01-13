import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  double money;
  Timestamp? lastTransferDate;
  Timestamp createdAt;
  Timestamp lastLogin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.money,
    required this.lastTransferDate,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      money: data['money']?.toDouble() ?? 0.0,
      lastTransferDate: data['last_transfer_date'],
      createdAt: data['created_at'],
      lastLogin: data['last_login'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'money': money,
      'last_transfer_date': lastTransferDate,
      'created_at': createdAt,
      'last_login': lastLogin,
    };
  }
}
