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
      amount: 336.1,
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
      amount: 1000.1,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Coffe',
      amount: 250.1,
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
      //enableDrag: true,
      isScrollControlled: true,
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

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final appBarWidget = AppBar(
      toolbarHeight: MediaQuery.of(context).orientation == Orientation.portrait
          ? (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.05
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
//виджет для отображения листа транзаций с отклченным Chart (переменная виджета должна быть определена ниже переменных которые в нем испольуются, в данном случае переменная appBar)
    final transactionsListWidgetChartDisabled = Container(
      height: isLandscape
          //если ориентация Portrait
          ? (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.92
          //если ориентация landscape
          : (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.95,
      child: _filerOn // если _filerOn = true - фильтруем список подставляя отфильтрованный список  _filteredTransactionList
          ? TransactionList(
              _filteredTransactionList,
              _deleteTransaction,
            )
          // если _filerOn = false - используем основной лист транзаций  _userTransactions который не изменяется при фильтрации
          : TransactionList(
              _userTransactions,
              _deleteTransaction,
            ),
    );

    final transactionsListWidgetChartEnabled = Container(
      height: isLandscape
          //если ориентация Portrait
          ? (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.72
          //если ориентация landscape
          : (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.52,
      child: _filerOn // если _filerOn = true - фильтруем список подставляя отфильтрованный список  _filteredTransactionList
          ? TransactionList(
              _filteredTransactionList,
              _deleteTransaction,
            )
          // если _filerOn = false - используем основной лист транзаций  _userTransactions который не изменяется при фильтрации
          : TransactionList(
              _userTransactions,
              _deleteTransaction,
            ),
    );

    return Scaffold(
      appBar:
          appBarWidget, //назначаем атрибуту переменную содержащую целый виджет
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Show chart'),
                Container(
                  height: isLandscape
                      ? MediaQuery.of(context).size.height * 0.05
                      : MediaQuery.of(context).size.height * 0.08,
                  child: Switch(
                    activeColor: Theme.of(context).colorScheme.secondary,
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
                ),
                Text('Transaction Filter'),
                Container(
                  height: isLandscape
                      ? MediaQuery.of(context).size.height * 0.05
                      : MediaQuery.of(context).size.height * 0.08,
                  child: Switch(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _filerOn,
                    onChanged: (value) {
                      setState(() {
                        //
                        _filerOn =
                            false; // !! строка позволяет отключать Switch. По дефолту отключен и не дает включить, чтобы управлять включение только через аргумент метода фильтра в
                      });
                    },
                  ),
                )
              ],
            ),
            _showChart
                // если Chart включен
                ? Column(
                    children: <Widget>[
                      Container(
                        height: isLandscape
                            //если ориентация Portrait
                            ? (MediaQuery.of(context).size.height -
                                    appBarWidget.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.2
                            //если ориентация landscape
                            : (MediaQuery.of(context).size.height -
                                    appBarWidget.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.4,
                        child: Chart(_recentTransactions, _filterTransaction),
                      ),
                      //показываем лист транзаций с размерами в соответствии с включенным Chart
                      transactionsListWidgetChartEnabled
                    ],
                  )
                // если Chart выключен
                //показываем лист транзаций с размерами в соответствии с Выключенным Chart
                : transactionsListWidgetChartDisabled
          ],
        ),
      ),
      floatingActionButton: Container(
        //alignment: Alignment.bottomCenter, // по дефолту снизу-справа
        child: FloatingActionButton(
          child: Icon(Icons.add),
          hoverColor: Colors.green,
          onPressed: () => _startAddNewTransaction(context),
        ),
      ),
    );
  }
}
