import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}

final transactionTemp = [
  Transaction(
    id: 't1',
    title: 'Products',
    amount: 1000,
    date: DateTime.utc(2023, 3, 30, 12, 00, 00),
  ),
  Transaction(
    id: 't2',
    title: 'Wear',
    amount: 500,
    date: DateTime.utc(2023, 3, 31, 12, 00, 00),
  ),
  Transaction(
    id: 't3',
    title: 'Coffe',
    amount: 750,
    date: DateTime.utc(2023, 3, 27, 12, 00, 00),
  ),
  Transaction(
    id: 't5',
    title: 'Products',
    amount: 500,
    date: DateTime.utc(2023, 3, 28, 12, 00, 00),
  ),
  Transaction(
    id: 't6',
    title: 'Products',
    amount: 1000,
    date: DateTime.now(),
  ),
  Transaction(
    id: 't7',
    title: 'Coffe',
    amount: 250,
    date: DateTime.utc(2023, 3, 25, 12, 00, 00),
  ),
  Transaction(
    id: 't8',
    title: 'Products',
    amount: 250,
    date: DateTime.utc(2023, 3, 24, 12, 00, 00),
  ),
  Transaction(
    id: 't9',
    title: 'Water',
    amount: 500,
    date: DateTime.utc(2023, 3, 29, 12, 00, 00),
  ),
  Transaction(
    id: 't10',
    title: 'Sweets',
    amount: 1000,
    date: DateTime.utc(2023, 3, 26, 12, 00, 00),
  ),
];
