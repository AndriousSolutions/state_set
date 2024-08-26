library state_set;

///
/// Copyright (C) 2024 Andrious Solutions
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
///          Created  08 Aug 2024
///
///

import 'package:flutter/foundation.dart'
    show
        ErrorDescription,
        FlutterError,
        FlutterErrorDetails,
        Key,
        ValueKey,
        VoidCallback,
        kDebugMode,
        mustCallSuper;

import 'package:flutter/material.dart'
    show
        BuildContext,
        ErrorDescription,
        FlutterError,
        FlutterErrorDetails,
        InheritedElement,
        InheritedWidget,
        Key,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        ValueKey,
        VoidCallback,
        Widget,
        WidgetBuilder,
        mustCallSuper;

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
}

/// Supplies an InheritedWidget to a State class
///
mixin InheritedWidgetStateMixin on State {
  /// A flag determining whether the built-in InheritedWidget is used or not.
  bool get useInherited => _useInherited;
  late bool _useInherited;

  // Collect any 'widgets' depending on this State's InheritedWidget.
  final Set<BuildContext> _dependencies = {};

  InheritedElement? _inheritedElement;

  // Widget passed to the InheritedWidget.
  Widget? _child;

  @override
  void initState() {
    super.initState();
    // Supply an identifier to the InheritedWidget
    _key = ValueKey<State>(this);
  }

  Key? _key;

  @override
  Widget build(BuildContext context) {
    _buildOverridden = false;
    if (useInherited) {
      _child ??= builder(context);
    } else {
      _child = builder(context);
    }
    return useInherited
        ? _StateXInheritedWidget(
            key: _key,
            mixin: this,
            child: _child ?? const SizedBox.shrink(),
          )
        : _child!;
  }

  /// A flag. Note if build() function was overridden or not.
  bool get buildOverridden => _buildOverridden;
  bool _buildOverridden = true;

  /// Use this function instead of the build() function
  ///
  Widget builder(BuildContext context) {
    _builderOverridden = false;
    return const SizedBox.shrink();
  }

  /// A flag. Note if builder() function was overridden or not.
  bool get builderOverridden => _builderOverridden;
  bool _builderOverridden = true;

  /// Determine if the dependencies should be updated.
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  ///
  ///  Set the specified widget (through its context) as a dependent of the InheritedWidget
  ///
  ///  Return false if not configured to use the InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) {
    final depend = useInherited && context != null;
    if (depend) {
      if (_inheritedElement == null) {
        _dependencies.add(context);
      } else {
        context.dependOnInheritedElement(_inheritedElement!);
      }
    }
    return depend;
  }

  /// In harmony with Flutter's own API there's also a notifyClients() function
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() {
    final inherited = useInherited;
    if (inherited) {
      setState(() {});
    }
    return inherited;
  }

  /// setState() will actually call an InheritedWidget again
  /// causing a rebuild of any and all dependencies.
  @override
  void setState(VoidCallback fn) {
    //
    try {
      super.setState(fn);
      // catch any errors if called inappropriately
    } catch (e, stack) {
      // Throw in DebugMode.
      if (kDebugMode) {
        rethrow;
      } else {
        //
        final details = FlutterErrorDetails(
          exception: e,
          stack: stack,
          library: 'state_extended.dart',
          context: ErrorDescription('setState() error in $this'),
        );
        // Resets the count of errors to show a complete error message not an abbreviated one.
        FlutterError.resetErrorCount();
        // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
        // Log the error.
        FlutterError.presentError(details);
      }
    }
  }

  /// Called when the State's InheritedWidget is called again
  /// This 'widget function' will be called again.
  Widget stateSet(WidgetBuilder? widgetFunc) {
    widgetFunc ??= (_) => const SizedBox.shrink();
    return useInherited
        ? _SetStateXWidget(mixin: this, widgetFunc: widgetFunc)
        : widgetFunc(context);
  }

  @override
  void dispose() {
    _key = null;
    _child = null;
    _inheritedElement = null;
    _dependencies.clear();
    super.dispose();
  }
}

/// The InheritedWidget used by State object
class _StateXInheritedWidget extends InheritedWidget {
  const _StateXInheritedWidget({
    super.key,
    required this.mixin,
    required super.child,
  });

  final InheritedWidgetStateMixin mixin;

  @override
  InheritedElement createElement() {
    //
    final element = InheritedElement(this);
    mixin._inheritedElement = element;
    // Associate any dependencies widgets to this InheritedWidget
    // toList(growable: false) prevent concurrent error
    for (final context in mixin._dependencies.toList(growable: false)) {
      context.dependOnInheritedElement(element);
      mixin._dependencies.remove(context);
    }
    return element;
  }

  /// Use the Mixin's updateShouldNotify() function
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      mixin.updateShouldNotify(oldWidget);
}

/// Supply a widget to depend upon a State's InheritedWidget
class _SetStateXWidget extends StatelessWidget {
  ///
  const _SetStateXWidget({
    required this.mixin,
    required this.widgetFunc,
  });
  final InheritedWidgetStateMixin mixin;
  final WidgetBuilder widgetFunc;

  @override
  Widget build(BuildContext context) {
    mixin.dependOnInheritedWidget(context);
    return widgetFunc(context);
  }
}
