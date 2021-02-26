library state_set;

///
/// Copyright (C) 2020 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  11 Dec 2020
///
///

import 'package:flutter/material.dart';

/// Manages the collection of State objects extended by the SetState class
mixin StateSet<T extends StatefulWidget> on State<T> {
  /// The static map of StateSet objects.
  static final Map<Type, State> _setStates = {};

  /// The static map of StatefulWidget objects.
  static final Map<Type, Type> _stateWidgets = {};

  /// Adds State object to a static map
  /// Adds StatefulWidget to a static map
  /// add this function to the State object's initState() function.
  @override
  void initState() {
    super.initState();
    _setStates.addAll({runtimeType: this});
    if (widget != null) {
      _stateWidgets.addAll({widget.runtimeType: runtimeType});
    }
  }

  static Widget _childStateSet;

  /// Builds a [InheritedWidget].
  ///
  /// Passed an alredy created widget tree
  /// so its setState() call will **only** rebuild
  /// [InheritedWidget] and consequently any of its dependents,
  @override
  Widget build(BuildContext context) {
    _childStateSet ??= builder(context);
    return _SetStateInheritedWidget(child: _childStateSet);
  }

  /// Use this function instead of the build() function to make this the 'root' State.
  Widget builder(BuildContext context) {
    return Container();
  }

  /// Remove objects from the static Maps if not already removed.
  /// add this function to the State object's dispose function instead
  @override
  void dispose() {
    // Sometimes a new State object was already created before
    // the old one was disposed.
    var remove = _setStates[runtimeType] == this;
    if (remove) {
      final state = _setStates.remove(runtimeType);
      remove = state != null;
      if (remove) {
        _stateWidgets.remove(state.widget?.runtimeType);
      }
    }
    super.dispose();
  }

  /// Retrieve the State object by its StatefulWidget
  /// Returns null if not found
  static State of<T extends StatefulWidget>() {
    final stateType = _stateWidgets.isEmpty ? null : _stateWidgets[_type<T>()];
    return _stateWidgets.isEmpty ? null : _setStates[stateType];
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  static State to<T extends State>() =>
      _setStates.isEmpty ? null : _setStates[_type<T>()];

  /// Retrieve the first StateSet object
  static StateSet get root =>
      _setStates.isEmpty ? null : _setStates.values.first;

  /// Retrieve the latest context (i.e. the last State object's context)
  static BuildContext get lastContext =>
      _setStates.isEmpty ? null : _setStates.values.last.context;

  /// Return the specified type from this function.
  static Type _type<T>() => T;

  /// Rebuilds the widget that calls this function
  /// by calling setState() function of the 'root' StatSet State object.
  bool attachStateSet(BuildContext context) {
    assert(_childStateSet != null,
        'Define a builder() function instead of build() function.');
    final widget =
        context.dependOnInheritedWidgetOfExactType<_SetStateInheritedWidget>();
    return widget != null;
  }

  ///
  static void refresh() => rebuild();

  static void rebuild() {
    assert(_childStateSet != null,
        'Define builder() instead of build() function.');
    return root?.setState(() {});
  }
}

/// Provides the InheritedWidget
class _SetStateInheritedWidget extends InheritedWidget {
  const _SetStateInheritedWidget({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

/// Implement so to serve as a Business Logic Component for a SetState object.
class StateBLoC<T extends State> {
  StateBLoC() {
    // Note, this is in case State object is available at this time.
    state = StateSet.to<T>();
  }

  /// The Subclass should supply the appropriate SetState object
  T state;

  /// Not necessary. May lead to confusion
  // /// Explicitly assign a State object but only if 'state' is null
  // bool assignState() {
  //   var assigned = state == null;
  //   if (assigned) {
  //     state = StateSet.to<T>();
  //     assigned = state != null;
  //   }
  //   return assigned;
  // }

  /// Call your State object.
  // ignore: invalid_use_of_protected_member
  void setState(VoidCallback fn) => state?.setState(fn);

  /// Supply the State object to this BloC object.
  @mustCallSuper
  void initState() {
    state = StateSet.to<T>();
  }

  /// Nullify its reference in the State object's own dispose() function.
  /// Should clean up memory.
  @mustCallSuper
  void dispose() {
    state = null;
  }
}
