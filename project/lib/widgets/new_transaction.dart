import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleComtroller =
      TextEditingController(); //   Creates a controller for an editable text field. This constructor treats a null [text] argument as if it were the empty string.
  final _amountController =
      TextEditingController(); //Creates a controller for an editable text field. This constructor treats a null [text] argument as if it were the empty string.
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleComtroller.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    } else if (enteredTitle.isNotEmpty &&
        enteredAmount >= 0 &&
        _selectedDate != null) {
      widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );
    } else if (enteredTitle.isNotEmpty &&
        enteredAmount >= 0 &&
        _selectedDate == null) {
      widget.addTx(
        enteredTitle,
        enteredAmount,
        DateTime.now(),
      ); // widget.addTx НЕ ПОНЯТНООООО! Что за конструкция и зачем нужна?
    }

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller:
                  _titleComtroller, // == onChanged: (val) => amountInput = val,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller:
                  _amountController, // == onChanged: (val) {titleInput = val;},
              keyboardType: TextInputType.number,
              onSubmitted: (_) =>
                  _submitData(), //почему бля с (_) тут? если сделать submitData() то дублирует запись когда нажимаешь галочку клаве а потом кнопку Submit (можно с () только если использовать Navigator.of(context).pop(); )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_selectedDate == null
                      ? 'Current date will be choosen or choose the date'
                      : DateFormat.yMd().format(_selectedDate)),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Chose the date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed:
                  _submitData, // а тут бля без (_) ? если сделать submitData() то дублирует запись когда нажимаешь галочку клаве а потом кнопку Submit (можно с () только если использовать Navigator.of(context).pop();, modal сам сворачивается если выполнен onSubmit или OnPress )
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
