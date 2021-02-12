import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/3/third_page.dart';

import 'package:example/src/my_bloc.dart';

/// Retain a State object by knowing the type you're looking for.
class ThirdPageBloc<T extends StateSet> extends CounterBloc<T> {
  /// POWERFUL: You can override the field, state, with a getter.
  /// As a getter, you don't have to instantiate until needed (and available).
  @override
  T get state => StateSet.to<T>();
}
