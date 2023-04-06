import 'dart:math';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
//задаем цвета каждому элементу листа Рандомом
  @override
  void initState() {
    const avaibleColors = [
      Color.fromARGB(255, 120, 244, 54),
      Color.fromARGB(255, 70, 80, 221),
      Color.fromARGB(255, 219, 11, 195)
    ];
    _bgColor = avaibleColors[Random().nextInt(3)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: Text('\$${widget.transaction.amount}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white))),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(widget.transaction.date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        // способ условия показа виджетов от размера экрана
        trailing: mediaQuery.size.width > 480
            ? TextButton.icon(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).disabledColor,
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'))
            : IconButton(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(Icons.delete),
                color: Theme.of(context).disabledColor),
      ),
    );
  }
}
