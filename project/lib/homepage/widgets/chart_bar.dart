import 'package:flutter/material.dart';

class ChartBar extends StatefulWidget {
  final String label;
  final double spendamount;
  final double spendingPctOTotal;
  final Function _filterCallBack;
  final bool filterdisabled;

  ChartBar(this.label, this.spendamount, this.spendingPctOTotal,
      this._filterCallBack, this.filterdisabled) {
    print(
        'Conctructor ChartBar'); //если ставить const перед конструктором - нельзя испольховать {...} в теле констуктора
  }

  @override
  State<ChartBar> createState() => _ChartBarState();
}

String activeElement;

class _ChartBarState extends State<ChartBar> {
  @override
  Widget build(BuildContext context) {
    print('ChartBar Widget build(BuildContext context) ');
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.10,
            child: FittedBox(
              child: Text('\$${widget.spendamount.toStringAsFixed(2)}'),
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
                  heightFactor: widget.spendingPctOTotal,
                  child: activeElement == widget.label &&
                          widget.filterdisabled != true
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                          ),
                        )
                      : Container(
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
              child: ListView(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      widget._filterCallBack(widget.label);
                      activeElement =
                          widget.label; //определяем активный элемент

                      setState(() {});
                    },
                    child: activeElement == widget.label &&
                            widget.filterdisabled != true //
                        ? Text(widget.label,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber))
                        : Text(widget.label,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                ],
              )),
        ],
      );
    });
  }
}
