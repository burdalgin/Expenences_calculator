import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'NO TRANSACTIONS',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: constraints.maxHeight * 0.3,
                  child: Image.asset(
                    'assets/images/simon.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                          child: Text('\$${transactions[index].amount}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white))),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMEEEEd().format(transactions[index].date),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // способ условия показа виджетов от размера экрана
                  trailing: mediaQuery.size.width > 480
                      ? TextButton.icon(
                          onPressed: () => deleteTx(transactions[index].id),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).disabledColor,
                          ),
                          icon: Icon(Icons.delete),
                          label: Text('Delete'))
                      : IconButton(
                          onPressed: () => deleteTx(transactions[index].id),
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).disabledColor),
                ),
              );
            },
          );
  }
}
