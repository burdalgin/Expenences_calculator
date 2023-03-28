import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final Function _filtrCallBack;

  Chart(this.recentTransactions, this._filtrCallBack);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues.map((keys) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  keys['day'],
                  keys['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (keys['amount'] as double) / totalSpending,
                  _filtrCallBack,
                ),
              );
            }).toList()),
      ),
    );
  }
}

/*class Chart extends StatelessWidget {
  final List<Transaction> transactions;
  Chart(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: transactions.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ChartBar(transactions);

            /*Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Icon(Icons.monetization_on_outlined),
                  ),
                  SizedBox(
                    height: 50,
                    width: 30,
                  ),
                  Container(
                    child: Text(transactions[index].amount.round().toString()),
                  ),
                ],
              ),
            );*/
          }),
    );
  }
}
*/
