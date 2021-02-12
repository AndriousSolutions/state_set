import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

class CounterBloc<T extends State> extends StateBLoC<T> {
  /// The 'data' is a lone integer.
  int _counter = 0;

  /// Getter to safely access the data.
  int get data => _counter;

  void onPressed() => setState(() {
        _counter++;
      });
}
