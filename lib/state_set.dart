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

/// Supply the StatefulWidget access to its State object and others
extension StateMapStatefulWidgetExtension on StatefulWidget {
  /// Retrieve a particular State class
  T? stateAs<T extends State>() {
    T? state;
    try {
      final obj = StateSet.stateIn(this);
      state = obj as T;
    } catch (e) {
      state = null;
    }
    return state;
  }

  /// Retrieve a State object from a StatefulWidget of this type.
  StateSet? stateOf() => StateSet.stateIn(this);

  /// Call setState() function from a StatefulWidget of this type.
  bool setStateOf(VoidCallback fn) {
    final state = StateSet.stateIn(this);
    // ignore: invalid_use_of_protected_member
    state?.setState(fn);
    return state != null;
  }

  /// Return the State object from this particular StatefulWidget.
  StateSet? get state => StateSet.stateIn(this);

  /// Call the setState() function from this particular StatefulWidget.
  bool setState(VoidCallback fn) => StateSet.setStateOf(this, fn);

  /// Call the setState() function from this particular StatefulWidget.
  @Deprecated('Use setState() instead. A recognized Flutter function.')
  bool refresh() => StateSet.refreshState(this);

  /// Call the setState() function from this particular StatefulWidget.
  @Deprecated('Use setState() instead. A recognized Flutter function.')
  bool rebuild() => refresh();

  /// Call the setState() function from this particular StatefulWidget.
  @Deprecated('Use setState() instead. A recognized Flutter function.')
  bool notifyListeners() => refresh();
}

//todo: Does this work?
/// Access other State object by their StatefulWidget
extension StateMapStateExtension on State {
  /// Retrieve a State object by its StatefulWidget
  static State? of(StatefulWidget widget) => StateSet.stateIn(widget);
}

/// Manages the collection of State objects extended by the SetState class
mixin StateSet<T extends StatefulWidget> on State<T> {
  //
  /// The static map of StateSet objects by Type.
  static final Map<Type, StateSet> _setStates = {};

  /// The static map of StatefulWidget objects.
  static final Map<Type, StateSet> _stateWidgets = {};

  /// The static map of StateSet objects by StatefulWidget.
  static final Map<StatefulWidget, StateSet> _statefulStates = {};

  /// Adds StatefulWidget to a static map
  /// add this function to the State object's initState() function.
  /// Adds State object to a static map
  @override
  void initState() {
    super.initState();
    _addThisState();
  }

  /// Switch out the old StatefulWidget object with the new one.
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _statefulStates.removeWhere((key, value) => key == oldWidget);
    _statefulStates[widget] = this;
  }

  /// In case the State object is reinserted in the Widget tree.
  @override
  void activate() {
    super.activate();
    _addThisState();
  }

  /// In case there is a 'hot reload' for example and the State object is re-created.
  @override
  void deactivate() {
    _removeThisState();
    super.deactivate();
  }

  /// Remove objects from the static Maps if not already removed.
  /// add this function to the State object's dispose function
  @override
  void dispose() {
    _removeThisState();
    super.dispose();
  }

  /// Add the 'current' State entry to the static objects
  void _addThisState() {
    _stateWidgets.addAll({widget.runtimeType: this});
    _statefulStates[widget] = this;
    _setStates.addAll({runtimeType: this});
  }

  /// Remove the 'current' State entry from the static objects
  void _removeThisState() {
    _stateWidgets.remove(widget.runtimeType);
    _statefulStates.removeWhere((key, value) => value == this);
    _setStates.removeWhere((key, value) => value == this);
  }

  /// 'Refresh' the State object's widget tree
  @Deprecated('Use setState() instead--a recognized Flutter function.')
  void refresh() => setState(() {});

  /// Retrieve the State object by its StatefulWidget
  /// Returns null if not found
  static StateSet? stateOf<T extends StatefulWidget>() =>
      _stateWidgets.isEmpty ? null : _stateWidgets[_type<T>()];

  /// Retrieve the type of State object by its StatefulWidget
  /// Returns null if not found
  static U? of<T extends StatefulWidget, U extends State>() {
    final state = _stateWidgets.isEmpty ? null : _stateWidgets[_type<T>()];
    U? result;
    if (state != null) {
      try {
        result = state as U;
      } catch (_) {
        result = null;
      }
    }
    return result;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  /// Note: If there's multiple State objects of the same type,
  /// will return the 'last' state object added to the Map, _setStates"
  static T? to<T extends State>() {
    final state = _setStates.isEmpty ? null : _setStates[_type<T>()];
    T? result;
    if (state != null) {
      try {
        result = state as T;
      } catch (_) {
        result = null;
      }
    }
    return result;
  }

  /// Retrieve the first StateSet object
  static StateSet? get root =>
      _stateWidgets.isEmpty ? null : _stateWidgets.values.first;

  /// Retrieve the latest context (i.e. the last State object's context)
  static BuildContext? get lastContext =>
      _stateWidgets.isEmpty ? null : _stateWidgets.values.last.context;

  /// Return the specified type from this function.
  static Type _type<T>() => T;

  /// Return the State object used by the specified StatefulWidget object.
  /// Usually called in the StatefulWidget passing 'this' as a parameter.
  static StateSet? stateIn(StatefulWidget? widget) =>
      widget == null ? null : _statefulStates[widget];

  /// Calls the setState() of the State objet from the specified StatefulWidget
  /// passing the specified function.
  /// Return true if successful.
  /// Usually called in the StatefulWidget passing 'this' as a parameter.
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
  /// Usually called in the StatefulWidget passing 'this' as a parameter.
  static bool refreshState(StatefulWidget? widget) => setStateOf(widget, () {});

  /// Call setState() from the State object from the specified StatefulWidget
  /// Return true if successful
  /// Usually called in the StatefulWidget passing 'this' as a parameter.
  static bool rebuildState(StatefulWidget? widget) => setStateOf(widget, () {});
}

/// Implement so to serve as a Business Logic Component for a SetState object.
class StateBLoC<T extends State> {
  /// Collect the designated State object to work with
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

/// Works with an InheritedWidget to allow for targeted and independent
/// rebuilds throughout your app. A powerful ability, you merely 'link' a
/// Widget to an InheritedWidget using .dependOnInheritedWidget(context)
/// and then call that InheritedWidget using .notifyClients() to rebuild its
/// dependencies.
///
/// /// Static API Example
/// import 'package:state_set/state_set.dart';
///
/// /// Static API
/// class APIImages extends StatelessWidget {
///   ///
///   const APIImages({Key? key}) : super(key: key);
///
///   static final InheritedWrap _branch = InheritedWrap<_ImageInherited>(
///     builder: (child) => _ImageInherited(child: child),
///     child: const HomePage(),
///   );
///
///   /// Link a widget to an InheritedWidget
///   static bool dependOnInheritedWidget(BuildContext? context) =>
///       _branch.dependOnInheritedWidget(context);
///
///   /// In harmony with Flutter's own API
///   static void notifyClients() => _branch.notifyClients();
///
///   /// Supply a Widget builder
///   static Widget setState({
///     Key? key,
///     required Widget Function(BuildContext context) builder,
///   }) =>
///       _SetState(key: key, builder: builder);
///
///   /// Determine if
///   static bool inBuilder = false;
///
///   @override
///   Widget build(BuildContext context) => _branch;
/// }
///
/// /// The InheritedWidget assigned 'dependent' child widgets.
/// class _ImageInherited extends InheritedWidget {
///   ///
///   const _ImageInherited({Key? key, required Widget child})
///       : super(key: key, child: child);
///
///   @override
///   bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
/// }
///
/// ///  Used like the function, setState(), to 'spontaneously' call
/// ///  build() functions here and there in your app. Much like the Scoped
/// ///  Model's ScopedModelDescendant() class.
/// ///  This class object will only rebuild if the InheritedWidget notifies it
/// ///  as it is a dependency.
/// class _SetState extends StatelessWidget {
///   /// Supply a 'builder' passing in the App's 'data object' and latest BuildContext object.
///   const _SetState({Key? key, required this.builder}) : super(key: key);
///
///   /// This is called with every rebuild of the App's inherited widget.
///   final Widget Function(BuildContext context) builder;
///
///   /// Calls the required Function object:
///   /// Function(BuildContext context)
///   @override
///   Widget build(BuildContext context) {
///     /// Go up the widget tree and link to the App's inherited widget.
///     context.dependOnInheritedWidgetOfExactType<_ImageInherited>();
///
///     APIImages.inBuilder = true;
///
///     final Widget widget = builder(context);
///
///     APIImages.inBuilder = false;
///
///     return widget;
///   }
/// }
class InheritedWrap<U extends InheritedWidget> extends StatefulWidget {
  ///
  const InheritedWrap({
    Key? key,
    required this.builder,
    required this.child,
  }) : super(key: key);

  /// Supply a child Widget to the returning InheritedWidget's child parameter.
  final U Function(Widget child) builder;

  /// The 'child' Widget eventually passed to the InheritedWidget.
  final Widget child;

  /// Link a widget to a InheritedWidget of type U
  bool dependOnInheritedWidget(BuildContext? context) {
    bool dependOn = context != null;
    if (dependOn) {
      final inheritedWidget = context.dependOnInheritedWidgetOfExactType<U>();
      dependOn = inheritedWidget != null;
    }
    return dependOn;
  }

  /// Notify any dependencies to be rebuilt.
  bool notifyClients() {
    final _state = state;
    final notified = _state != null;
    if (notified) {
      // ignore: invalid_use_of_protected_member
      _state.setState(() {});
    }
    return notified;
  }

  /// Calls setState() function in the Widget's State object.
  // ignore: invalid_use_of_protected_member
  void setState(VoidCallback fn) => state?.setState(fn);

  @override
  State createState() => _InheritedWrapState();
}

class _InheritedWrapState extends State<InheritedWrap> with StateSet {
  @override
  Widget build(BuildContext context) => widget.builder(widget.child);
}
