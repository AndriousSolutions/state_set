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

extension StateMapStatefulWidgetExtension on StatefulWidget {
  //
  T? stateAs<T extends State>() {
    T? state;
    try {
      // Try in case its a bad cast
      state = StateSet.stateIn(this) as T;
    } catch (e) {
      state = null;
    }
    return state;
  }

  /// Retrieve a State object from a StatefulWidget of this type.
  /// Not nessecarily this one.
  StateSet? stateOf() => StateSet._stateOf(this);

  /// Call setState() function from a StatefulWidget of this type.
  bool setStateOf(VoidCallback fn) {
    final state = StateSet._stateOf(this);
    state?.setState(fn);
    return state != null;
  }

  /// Return the State object from this particular StatefulWidget.
  StateSet? get state => StateSet.stateIn(this);

  /// Call the setState() function from this particular StatefulWidget.
  bool setState(VoidCallback fn) => StateSet.setStateOf(this, fn);

  bool refresh() => StateSet.refreshState(this);

  bool rebuild() => refresh();

  bool notifyListeners() => refresh();
}

/// Does this work?
extension StateMapStateExtension on State {
  static State? of(StatefulWidget widget) => StateSet.stateIn(widget);
}

/// Manages the collection of State objects extended by the SetState class
mixin StateSet<T extends StatefulWidget> on State<T> {
  /// The static map of StateSet objects by Type.
  static final Map<Type, StateSet> _setStates = {};

  /// The static map of StatefulWidget objects.
  static final Map<Type, Type> _stateWidgets = {};

  /// The static map of StateSet objects by StatefulWidget.
  static final Map<StatefulWidget, StateSet> _statefulStates = {};

  /// Adds State object to a static map
  /// Adds StatefulWidget to a static map
  /// add this function to the State object's initState() function.
  @override
  void initState() {
    super.initState();
    _setStates.addAll({runtimeType: this});
    _stateWidgets.addAll({widget.runtimeType: runtimeType});
    _statefulStates[widget] = this;
  }

  /// Switch out the old StatefulWidget object with the new one.
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _statefulStates.removeWhere((key, value) => key == oldWidget);
    _statefulStates[widget] = this;
  }

  static Widget? _childStateSet;

  /// Builds a [InheritedWidget].
  ///
  /// Passed an already created widget tree
  /// so its setState() call will **only** rebuild
  /// [InheritedWidget] and consequently any of its dependents,
  @override
  Widget build(BuildContext context) {
    _childStateSet ??= builder(context);
    return _SetStateInheritedWidget(child: _childStateSet!);
  }

  /// Override this function instead of the build() function to make this the 'root' State.
  Widget builder(BuildContext context) => Container();

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
        _stateWidgets.remove(state.widget.runtimeType);
      }
    }
    _statefulStates.removeWhere((key, value) => value == this);
    super.dispose();
  }

  /// Retrieve the State object by its StatefulWidget
  /// Returns null if not found
  static StateSet? stateOf<T extends StatefulWidget>() {
    final stateType = _stateWidgets.isEmpty ? null : _stateWidgets[_type<T>()];
    StateSet? state;
    if (_setStates.isEmpty || stateType == null) {
      state = null;
    } else {
      state = _setStates[stateType];
    }
    return state;
  }

  /// Retrieve the State object of a type of StatefulWidget
  /// Not necessary the StatefulWidget that call this function.
  static StateSet? _stateOf(StatefulWidget widget) {
    final stateType =
        _stateWidgets.isEmpty ? null : _stateWidgets[widget.runtimeType];
    StateSet? state;
    if (_setStates.isEmpty || stateType == null) {
      state = null;
    } else {
      state = _setStates[stateType];
    }
    return state;
  }

  /// Retrieve the type of State object by its StatefulWidget
  /// Returns null if not found
  static U? of<T extends StatefulWidget, U extends State>() {
    final stateType = _stateWidgets.isEmpty ? null : _stateWidgets[_type<T>()];
    StateSet? state;
    if (_setStates.isEmpty || stateType == null) {
      state = null;
    } else {
      state = _setStates[stateType];
    }
    // ignore: avoid_as
    return state == null ? null : state as U;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  static T? to<T extends State>() {
    StateSet? state;
    if (_setStates.isEmpty) {
      state = null;
    } else {
      state = _setStates[_type<T>()];
    }
    // ignore: avoid_as
    return state == null ? null : state as T;
  }

  /// Retrieve the first StateSet object
  static StateSet? get root =>
      // ignore: avoid_as
      _setStates.isEmpty ? null : _setStates.values.first;

  /// Retrieve the latest context (i.e. the last State object's context)
  static BuildContext? get lastContext =>
      _setStates.isEmpty ? null : _setStates.values.last.context;

  /// Return the specified type from this function.
  static Type _type<T>() => T;

  /// Return the State object used by the specified StatefulWidget object.
  static StateSet? stateIn(StatefulWidget? widget) =>
      widget == null ? null : _statefulStates[widget];

  /// Calls the setState() of the State objet from the specified StatefulWidget
  /// passing the specified function.
  /// Return true if successful
  static bool setStateOf(StatefulWidget? widget, VoidCallback? fn) {
    bool set;

    final state = stateIn(widget);

    set = state != null;

    if (set) {
      set = state.mounted;
    }

    if (set) {
      set = fn != null;
    }

    if (set) {
      state!.setState(fn!);
    }
    return set;
  }

  /// Call setState() from the State object from the specified StatefulWidget
  /// Return true if successful
  static bool refreshState(StatefulWidget? widget) => setStateOf(widget, () {});

  /// Call setState() from the State object from the specified StatefulWidget
  /// Return true if successful
  static bool rebuildState(StatefulWidget? widget) => setStateOf(widget, () {});

  /// Rebuilds the widget that calls this function
  /// by calling setState() function of the 'root' StatSet State object.
  bool attachStateSet(BuildContext context) {
    assert(_childStateSet != null,
        'attachStateSet(): Define a builder() function instead of build() function.');
    final widget =
        context.dependOnInheritedWidgetOfExactType<_SetStateInheritedWidget>();
    return widget != null;
  }

  /// Adhered to the Bloc syntax
  static void notifyListeners() => rebuild();

  /// Flutter framework function name.
  static void notifyClients() => rebuild();

  /// 'Refresh' the widget tree
  static void refresh() => rebuild();

  /// Rebuild widget tree using the 'first' StateSet State objects.
  static void rebuild() {
    assert(_childStateSet != null,
        'rebuild(): Define builder() instead of build() function.');
    return root?.setState(() {});
  }
}

/// Provides the InheritedWidget
class _SetStateInheritedWidget extends InheritedWidget {
  const _SetStateInheritedWidget({Key? key, required Widget child})
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
  T? state;

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
