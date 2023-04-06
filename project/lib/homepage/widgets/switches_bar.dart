import 'package:flutter/material.dart';

class SwitchesBar extends StatefulWidget {
  MediaQueryData mediaQuery;
  bool isPortrait;
  Function filterSwitchCallback;
  Function showChartSwitchCallback;
  bool filerOn;
  bool showChart;

  SwitchesBar(this.isPortrait, this.mediaQuery, this.filterSwitchCallback,
      this.filerOn, this.showChart, this.showChartSwitchCallback);

  @override
  State<SwitchesBar> createState() => _SwitchesBar();
}

class _SwitchesBar extends State<SwitchesBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text(
            'Show chart'), //когда const Build() не будет его перерисовывать
        Container(
          height: widget.isPortrait
              ? widget.mediaQuery.size.height * 0.05
              : widget.mediaQuery.size.height * 0.08,
          //adaptive consctructor позволяет автоматически изменять отображение элемента в зависимости от платформы
          child: Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: widget.showChart,
            onChanged: (value) => widget.showChartSwitchCallback(value),
          ),
        ),
        const Text('Transaction Filter'),
        Container(
          height: widget.isPortrait
              ? widget.mediaQuery.size.height * 0.05
              : widget.mediaQuery.size.height * 0.08,
          //adaptive consctructor позволяет автоматически изменять отображение элемента в зависимости от платформы
          child: Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: widget.filerOn,
            onChanged: (value) => widget.filterSwitchCallback(value),
          ),
        )
      ],
    );
  }
}
