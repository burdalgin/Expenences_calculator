import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

/*void main() {
  //для того чтобы SystemChrome.setPreferredOrientations точно работали
  WidgetsFlutterBinding.ensureInitialized();
  //фиксируем доступные ориентации экрана
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expences',
      theme: ThemeData(
        primaryColor: Colors.green,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                titleLarge:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )
              .titleLarge,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.amber),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Products',
      amount: 202.1,
      date: DateTime.utc(2023, 3, 23, 12, 00, 00),
    ),
    Transaction(
      id: 't2',
      title: 'Wear',
      amount: 120.2,
      date: DateTime.utc(2023, 3, 26, 12, 00, 00),
    ),
    Transaction(
      id: 't3',
      title: 'Coffe',
      amount: 101.1,
      date: DateTime.utc(2023, 3, 27, 12, 00, 00),
    ),
    Transaction(
      id: 't4',
      title: 'Products',
      amount: 250.1,
      date: DateTime.utc(2023, 3, 28, 12, 00, 00),
    ),
    Transaction(
      id: 't5',
      title: 'Products',
      amount: 340.1,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Coffe',
      amount: 130.1,
      date: DateTime.utc(2023, 3, 25, 12, 00, 00),
    ),
    Transaction(
      id: 't4',
      title: 'Products',
      amount: 130.1,
      date: DateTime.utc(2023, 3, 24, 12, 00, 00),
    ),
    Transaction(
      id: 't4',
      title: 'Water',
      amount: 30.1,
      date: DateTime.utc(2023, 3, 29, 12, 00, 00),
    ),
    Transaction(
      id: 't4',
      title: 'Sweets',
      amount: 550.1,
      date: DateTime.utc(2023, 3, 22, 12, 00, 00),
    ),
  ];

  bool _showChart = true; // переменная переключателя отображения виджета Chart
  bool _filerOn =
      false; // переменная переключателя фильтра по умолчанию фильтр отключен

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Transaction> _filteredTransactionList = [];

  void _filterTransaction(String weekDay) {
    setState(() {
      _filteredTransactionList = _userTransactions
          .where((element) =>
              DateFormat.E().format(element.date).contains(weekDay))
          .toList();

      _filerOn = true; //делаем Swicth фильтра enabled
    });
  }

  //void _filterCancel() {}

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      toolbarHeight: MediaQuery.of(context).orientation == Orientation.portrait
          ? (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.06
          : (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.1,
      title: Text('Personal Expences'),
      actions: <Widget>[
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );

    return Scaffold(
      appBar: appBar, //назначаем атрибуту переменную содержащую целый выджет
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Show chart'),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                        if (_showChart == false)
                          _filerOn =
                              false; // если отключаем отображение Chart то отключаем фильтр
                      });
                    },
                  ),
                  Text('Transaction Filter'),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: _filerOn,
                    onChanged: (value) {
                      setState(() {
                        _filerOn = false;
                        // !! позволяет переключать Switch
                      });
                    },
                  )
                ]),
            _showChart
                ? Column(children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? (MediaQuery.of(context).size.height -
                                  //appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.2
                          : (MediaQuery.of(context).size.height -
                                  //appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.4,
                      child: Chart(_recentTransactions, _filterTransaction),
                    ),
                    Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? (MediaQuery.of(context).size.height -
                                    //appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.7
                            : (MediaQuery.of(context).size.height -
                                    //appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.5,
                        child: _filerOn // если _filerOn = true - фильтруем список подставляя отфильтрованный список  _filteredTransactionList
                            ? TransactionList(
                                _filteredTransactionList,
                                _deleteTransaction,
                              )
                            // если _filerOn = false - используем основной лист транзаций  _userTransactions который не изменяется при фильтрации
                            : TransactionList(
                                _userTransactions,
                                _deleteTransaction,
                              )),
                  ])
                : Container(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? (MediaQuery.of(context).size.height -
                                //appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.7
                        : (MediaQuery.of(context).size.height -
                                //appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.5,
                    child: _filerOn // если _filerOn = true - фильтруем список подставляя отфильтрованный список  _filteredTransactionList
                        ? TransactionList(
                            _filteredTransactionList,
                            _deleteTransaction,
                          )
                        // если _filerOn = false - используем основной лист транзаций  _userTransactions который не изменяется при фильтрации
                        : TransactionList(
                            _userTransactions,
                            _deleteTransaction,
                          )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        hoverColor: Colors.green,
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
