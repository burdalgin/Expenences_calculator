import 'package:flutter/material.dart';
import '../models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx) {
    print('Constructor TransactionList(this.transactions, this.deleteTx)');
  }

  @override
  Widget build(BuildContext context) {
    print('TransactionList Widget build(BuildContext context) ');

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
        //используется Key, для помощи движку соединить элементы WidgetTree и ElementTree  для назначения каждому элементу листа уникальный Key, для того чтобы не перезаписывался его State при изменениия состава <List>.
        //без ключей Flutter просто сопоставляет WidgetTree и ElementTree по типу Widgets
        // if you're not using keys. Flutter may attach a state object to the wrong widget (if widgets moved or where deleted)
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx
                          .id), //можно использовать UniqueKey() но лучше четко обозначать к какому полю листа привязываеся
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
          );
  }
}
