import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:intl/intl.dart';

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
    return Platform.isIOS
        //Показываем основыне настройки для IOS
        ? CupertinoApp(
            title: 'Personal Expences',
            theme: CupertinoThemeData(
                primaryColor: Platform.isIOS ? Colors.blue : Colors.green

                /* // Потом надо найти какая замена аргументов у CupertinoApp в отличии от Material
              textTheme: CupertinoThemeData.const.copyWith(
                    titleSmall:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    titleMedium:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    titleLarge:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  .copyWith(secondary: Colors.amber), */
                ),
            home: MyHomePage(),
          )
        //Показываем основыне настройки для Android
        : MaterialApp(
            title: 'Personal Expences',
            theme: ThemeData(
              primaryColor: Colors.green,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    titleSmall:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    titleMedium:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    titleLarge:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      id: 't5',
      title: 'Products',
      amount: 250.1,
      date: DateTime.utc(2023, 3, 28, 12, 00, 00),
    ),
    Transaction(
      id: 't6',
      title: 'Products',
      amount: 1000.1,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'Coffe',
      amount: 250.1,
      date: DateTime.utc(2023, 3, 25, 12, 00, 00),
    ),
    Transaction(
      id: 't8',
      title: 'Products',
      amount: 130.1,
      date: DateTime.utc(2023, 3, 24, 12, 00, 00),
    ),
    Transaction(
      id: 't9',
      title: 'Water',
      amount: 30.1,
      date: DateTime.utc(2023, 3, 29, 12, 00, 00),
    ),
    Transaction(
      id: 't10',
      title: 'Sweets',
      amount: 550.1,
      date: DateTime.utc(2023, 3, 22, 12, 00, 00),
    ),
  ];

  bool _showChart = true; // переменная переключателя отображения виджета Chart
  bool _filerOn =
      false; // переменная переключателя фильтра по умолчанию фильтр отключен
  bool
      _filterDisablevalue; // если True отключает выделение кнопок фильтра (Дней недели на ChartBar)

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
      _filteredTransactionList.add(newTx);
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
      _filteredTransactionList.removeWhere((tx) => tx.id == id);
    });
  }

  List<Transaction> _filteredTransactionList = [];

  void _filterTransaction(String weekDay) {
    setState(() {
      _filteredTransactionList = _userTransactions
          .where((element) =>
              DateFormat.E().format(element.date).contains(weekDay))
          .toList();
      _filerOn = true;
      _filterDisablevalue = false; //делаем Swicth фильтра enabled
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isPortrait = mediaQuery.orientation == Orientation.portrait;

//Добавляем тип для виджета PreferredsizeWidget что бы при проверке платформы Dart понимал тип заранее, и можно было использовать параметр appBarWidget.preferredSize.height
    final PreferredSizeWidget appBarWidget = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expences'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //ограничиваем что то
              children: <Widget>[
                //создаем свою кнопку потому что в Cupertino нет IconButton
                GestureDetector(
                  child: Icon(CupertinoIcons.add_circled),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            toolbarHeight: mediaQuery.orientation == Orientation.portrait
                ? (mediaQuery.size.height - mediaQuery.padding.top) * 0.05
                : (mediaQuery.size.height - mediaQuery.padding.top) * 0.1,
            title: Text('Personal Expences'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
//виджет для отображения листа транзаций с отклченным Chart (переменная виджета должна быть определена ниже переменных которые в нем испольуются, в данном случае переменная appBar)
    final transactionsListWidgetChartDisabled = Container(
      height: isPortrait
          //если ориентация Portrait
          ? (mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  mediaQuery.padding.top) *
              0.92
          //если ориентация landscape
          : (mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  mediaQuery.padding.top) *
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
      height: isPortrait
          //если ориентация Portrait
          ? (mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  mediaQuery.padding.top) *
              0.72
          //если ориентация landscape
          : (mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  mediaQuery.padding.top) *
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

    final switchesBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('Show chart'),
        Container(
          height: isPortrait
              ? mediaQuery.size.height * 0.05
              : mediaQuery.size.height * 0.08,
          //adaptive consctructor позволяет автоматически изменять отображение элемента в зависимости от платформы
          child: Switch.adaptive(
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
          height: isPortrait
              ? mediaQuery.size.height * 0.05
              : mediaQuery.size.height * 0.08,
          //adaptive consctructor позволяет автоматически изменять отображение элемента в зависимости от платформы
          child: Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _filerOn,
            onChanged: (value) {
              setState(() {
                _filerOn = false;

                _filterDisablevalue = !_filerOn;

                // !! строка позволяет отключать Switch. По дефолту отключен и не дает включить, чтобы управлять включение только через аргумент метода фильтра в
              });
            },
          ),
        )
      ],
    );

// в начале заворачиваем в SafeArea для того чтобы учесть все зарезервированные участки экрана в зависимости от платформы
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            switchesBar, //показываем контейнер со Swithes
            _showChart
                // если _showChart = true Chart показываем
                ? Column(
                    children: <Widget>[
                      Container(
                        height: isPortrait
                            //если ориентация Portrait
                            ? (mediaQuery.size.height -
                                    appBarWidget.preferredSize.height -
                                    mediaQuery.padding.top) *
                                0.2
                            //если ориентация landscape
                            : (mediaQuery.size.height -
                                    appBarWidget.preferredSize.height -
                                    mediaQuery.padding.top) *
                                0.4,
                        child: Chart(_recentTransactions, _filterTransaction,
                            _filterDisablevalue),
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
    );

//В зависимости
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBarWidget,
          )
        : Scaffold(
            appBar:
                appBarWidget, //назначаем атрибуту переменную содержащую целый виджет
            body: appBody,
            //alignment: Alignment.bottomCenter, // по дефолту снизу-справа
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //Условие показа элемента в зависимости от платформы (нужно подключать Dart.io)
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    hoverColor: Colors.green,
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
