import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:intl/intl.dart';
import './widgets/app_bar.dart';
import './widgets/switches_bar.dart';

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
    print('Widget build(BuildContext context) MyApp');
    return Platform.isIOS
        //Устанавливаем основыне настройки для IOS
        ? CupertinoApp(
            title: 'Personal Expences',
            theme: CupertinoThemeData(
              primaryColor: Colors.blue,
              barBackgroundColor: Colors.green,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            home: MyHomePage(),
          )
        //Устанавливаем основыне настройки для Android
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
/////////////////////VARS/////////////////////////////////////////////////////
  List<Transaction> _userTransactions = transactionTemp;

  bool _showChart = true; // переменная переключателя отображения виджета Chart
  bool _filerOn =
      false; // переменная переключателя фильтра по умолчанию фильтр отключен
  bool
      _filterDisablevalue; // если True отключает выделение кнопок фильтра (Дней недели на ChartBar)

  List<Transaction> _filteredTransactionList = [];

/////////////////////METHODS/////////////////////////////////////////////////////
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void didChangeApplifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    print('void _addNewTransactions');
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
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        //почему тут не используется context??????
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    print(' void _deleteTransaction(String id)');
    setState(
      () {
        _userTransactions.removeWhere((tx) => tx.id == id);
        _filteredTransactionList.removeWhere((tx) => tx.id == id);
      },
    );
  }

  void _filterTransaction(String weekDay) {
    print('void _filterTransaction(String weekDay)');
    setState(
      () {
        _filteredTransactionList = _userTransactions
            .where((element) =>
                DateFormat.E().format(element.date).contains(weekDay))
            .toList();
        _filerOn = true;
        _filterDisablevalue =
            false; //делаем Swicth фильтра enabled, иначе при инициализации MyhomepageState применяется bool _filerOn = false и выделение фильтров не работает
      },
    );
  }

  void _filterSwitch(value) {
    print('_filterSwitch');
    setState(
      () {
// !! строка позволяет отключать Switch. По дефолту отключен и не дает включить, чтобы управлять включение только через аргумент метода фильтра в
        _filerOn = value;
        //сбрасываем выделение элементов фильтра если откючаем фильтр
        _filterDisablevalue = !_filerOn;
      },
    );
  }

  void _chartShowSwitch(value) {
    print('_chartShowSwitch');
    setState(
      () {
        _showChart = value;
        // если отключаем отображение Chart то отключаемSwitch фильтра и сбрасываем выделение элементов фильтра
        if (_showChart == false) {
          _filerOn = false;
          _filterDisablevalue = true;
        }
      },
    );
  }
////////////////// Widget Builder Method Example /////////////////////////

// Если применять _buildAppBarWidget то в других испоьзуется переменная содержащая виджет appBarWidget
  /* PreferredSizeWidget _buildAppBarWidget(
      mediaQueryData _mediaQuery, _isPortrait) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expences'),
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
            toolbarHeight: _isPortrait
                ? (_mediaQuery.size.height - _mediaQuery.padding.top) * 0.05
                : (_mediaQuery.size.height - _mediaQuery.padding.top) * 0.1,
            title: const Text('Personal Expences'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
  }*/

////////////////// Widget Builder Method Example \\\\\\\\\\\\\\\\\\\\\\\\\\

//My HomePage Build()
  @override
  Widget build(BuildContext context) {
    print('Widget build MyHomepage');
    final _mediaQuery = MediaQuery.of(context);
    final _isPortrait = _mediaQuery.orientation == Orientation.portrait;

//Добавляем тип для виджета PreferredsizeWidget что бы при проверке платформы Dart понимал тип заранее, и можно было использовать параметр appBarWidget.preferredSize.height
    final PreferredSizeWidget appBarWidget = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expences'),
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
            toolbarHeight: _mediaQuery.orientation == Orientation.portrait
                ? (_mediaQuery.size.height - _mediaQuery.padding.top) * 0.05
                : (_mediaQuery.size.height - _mediaQuery.padding.top) * 0.1,
            title: const Text('Personal Expences'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
//виджет для отображения листа транзаций с отклченным Chart (переменная виджета должна быть определена выше переменных которые в нем испольуются, в данном случае переменная appBar)
    final Widget transactionsListWidgetChartDisabled = Container(
      height: _isPortrait
          //если ориентация Portrait
          ? (_mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  _mediaQuery.padding.top) *
              0.92
          //если ориентация landscape
          : (_mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  _mediaQuery.padding.top) *
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
//виджет для отображения листа транзаций с включенным Chart (переменная виджета должна быть определена выше переменных которые в нем испольуются, в данном случае переменная appBar)
    final Widget transactionsListWidgetChartEnabled = Container(
      height: _isPortrait
          //если ориентация Portrait
          ? (_mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  _mediaQuery.padding.top) *
              0.72
          //если ориентация landscape
          : (_mediaQuery.size.height -
                  appBarWidget.preferredSize.height -
                  _mediaQuery.padding.top) *
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

//Виджет Body
// в начале заворачиваем в SafeArea для того чтобы учесть все зарезервированные участки экрана в зависимости от платформы
    final Widget appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SwitchesBar(_isPortrait, _mediaQuery, _filterSwitch, _filerOn,
                _showChart, _chartShowSwitch), //показываем контейнер со Swithes
            _showChart
                // если _showChart = true Chart показываем
                ? Column(
                    children: <Widget>[
                      Container(
                        height: _isPortrait
                            //если ориентация Portrait
                            ? (_mediaQuery.size.height -
                                    appBarWidget.preferredSize.height -
                                    _mediaQuery.padding.top) *
                                0.2
                            //если ориентация landscape
                            : (_mediaQuery.size.height -
                                    appBarWidget.preferredSize.height -
                                    _mediaQuery.padding.top) *
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

//My HomePage Build() return Scaffold в зависимости от платформы
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBarWidget,
          )
        : Scaffold(
            appBar: appBarWidget,
            //назначаем атрибуту метод построения виджета appBar
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
