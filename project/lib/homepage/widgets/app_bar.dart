//пока что не имплементировал в Main. Трудности с PreferedSize

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final Function startAddNewTransactionCallback;
  final mediaQuery;

  AppBarWidget(
    this.startAddNewTransactionCallback,
    this.mediaQuery,
  );

  @override
  AppBarWidget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expences'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, //ограничиваем что то
              children: <Widget>[
                //создаем свою кнопку потому что в Cupertino нет IconButton
                GestureDetector(
                  child: Icon(CupertinoIcons.add_circled),
                  onTap: () => startAddNewTransactionCallback(context),
                )
              ],
            ),
          )
        : AppBar(
            toolbarHeight: mediaQuery.orientation == Orientation.portrait
                ? (mediaQuery.size.height - mediaQuery.padding.top) * 0.05
                : (mediaQuery.size.height - mediaQuery.padding.top) * 0.1,
            title: const Text('Personal Expences'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => startAddNewTransactionCallback(context),
                  icon: Icon(Icons.add))
            ],
          );
  }
}
