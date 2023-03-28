import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendamount;
  final double spendingPctOTotal;
  final Function _filtrCallBack;

  ChartBar(
    this.label,
    this.spendamount,
    this.spendingPctOTotal,
    this._filtrCallBack,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.10,
            child: FittedBox(
              child: Text('\$${spendamount.toStringAsFixed(2)}'),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.5,
            width: 30,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.25,
            child: TextButton(
                onPressed: () => _filtrCallBack(label),
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ],
      );
    });
  }
}






/*

class ChartBar extends StatefulWidget {
  
  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
 

  @override
  Widget build(BuildContext context) {
    return Card(
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
            child: Text(widget.transactions[index].amount.toString()),
          ),
        ],
      ),
    );
  }
}
*/