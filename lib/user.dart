import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String image;
  final String username;
  final String password;
  final String email;
  final int totalMoneyIn;
  final int totalMoneyOut;
  final int balance;

  Users({
    required this.id,
    required this.image,
    required this.username,
    required this.password,
    required this.email,
    required this.totalMoneyIn,
    required this.totalMoneyOut,
    required this.balance,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'username': username,
        'password': password,
        'email': email,
        'totalMoneyIn': totalMoneyIn,
        'totalMoneyOut': totalMoneyOut,
        'balance': balance,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        image: json['image'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        totalMoneyIn: json['totalMoneyIn'],
        totalMoneyOut: json['totalMoneyOut'],
        balance: json['balance'],
      );
}

class Transactions {
  final String id;
  final String addType;
  final String date;
  final String time;
  final int amount;
  final String note;

  Transactions({
    required this.id,
    required this.addType,
    required this.date,
    required this.time,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'time': time,
        'addType': addType,
        'amount': amount,
        'note': note,
      };

  static Transactions fromJson(Map<String, dynamic> json) => Transactions(
        id: json['id'],
        addType: json['addType'],
        date: json['date'],
        time: json['time'],
        amount: json['amount'],
        note: json['note'],
      );
}

// class moneyIn {
//   // final String uid;
//   // final String id;
//   // final String datetime;
//   final String amount;
//   final String note;
//   final String sales_category;

//   moneyIn({
//     // required this.uid,
//     // required this.id,
//     // required this.datetime,
//     required this.amount,
//     required this.note,
//     required this.sales_category,
//   });

//   Map<String, dynamic> toJson() => {
//         'amount': amount,
//         'note': note,
//         'sales_category': sales_category,
//         // 'email': email,
//       };

//   static moneyIn fromJson(Map<String, dynamic> json) => moneyIn(
//         amount: json['amount'],
//         note: json['note'],
//         sales_category: json['sales_category'],
//         // email: json['email'],
//       );
// }

// class moneyOut {
//   final String amount;
//   final String note;
//   final String expense_category;

//   moneyOut({
//     required this.amount,
//     required this.note,
//     required this.expense_category,
//   });

//   Map<String, dynamic> toJson() => {
//         'amount': amount,
//         'note': note,
//         'expense_category': expense_category,
//       };

//   static moneyOut fromJson(Map<String, dynamic> json) => moneyOut(
//         amount: json['amount'],
//         note: json['note'],
//         expense_category: json['sales_category'],
//         // email: json['email'],
//       );
// }
