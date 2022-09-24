import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with StateSet {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        /// Key identifies the widget. New key? New widget!
        /// Demonstrates how to explicitly 're-create' a State object
        home: Page1(key: UniqueKey()),
      );
}

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State createState() => _Page1State();

  void onPressed() {
    //
    _Page1State? state = stateAs<_Page1State>();

    /// Notice casting is necessary to call the unique property, count.
    state = this.state as _Page1State?;
    state = StateSet.stateIn(this) as _Page1State?;
    state = StateSet.stateOf<Page1>() as _Page1State?;
    state = StateSet.of<Page1, _Page1State>();
    state = StateSet.to<_Page1State>();
    // This setState() function is defined below.
    setState(() => state!.count++);
  }

  void setState(VoidCallback fn) {
    //
    State? state;

    /// Notice casting is not necessary when call a State's setState() function.
    state = this.state; // uses StateSet.stateIn(this);
    state = StateSet.stateIn(this); // uses _statefulStates[widget];
    state = StateSet.stateOf<Page1>(); // uses  _stateWidgets[_type<T>()];
    state =
        StateSet.of<Page1, _Page1State>(); // uses _stateWidgets[_type<T>()];
    state = StateSet.to<_Page1State>(); // uses _setStates[_type<T>()];

    // ignore: invalid_use_of_protected_member
    state?.setState(fn);
  }

  void refresh() {
    final specificState =
        stateAs<_Page1State>(); // uses StateSet.stateIn(this);
    // ignore: invalid_use_of_protected_member
    specificState?.setState(() {});
  }
}

class _Page1State extends _PageState<Page1> {
  @override
  void initState() {
    // Place a breakpoint here and you'll find this
    // function will run again with the button, New Key for Page 1,
    // is pressed. The State objet is re-created.
    super.initState();
  }

  @override
  Widget build(BuildContext context) => buildPage1(
        count: count,
        counter: widget.onPressed,
      );
}

/// The second page displayed in this app.
class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State createState() => _Page2State();

  void onPressed() {
    /// Cast to the appropriate State class to increment the count.
    var state = stateAs<_Page2State>();
    state = this.state as _Page2State?;
    state = StateSet.stateIn(this) as _Page2State?;
    state = StateSet.stateOf<Page2>() as _Page2State?;
    state = StateSet.of<Page2, _Page2State>();
    state = StateSet.to<_Page2State>();

    state?.count++;

    /// You can call this variable's setState() function. Ignore the warning below.
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }
}

class _Page2State extends _PageState<Page2> {
  //
  @override
  Widget build(BuildContext context) => buildPage2(
        count: count,
        counter: widget.onPressed,
        page1counter: () {
          /// StatefulWidget is const and so is not created again. Brilliant!
          const Page1().onPressed();
        },
      );
}

/// The third page displayed in this app.
class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State createState() => _Page3State();

  void onPressed() {
    //
    /// Retrieve the appropriate State object
    _Page3State? state;

    state = stateAs<_Page3State>(); // uses StateSet.stateIn(this);
    state = this.state as _Page3State?; // uses StateSet.stateIn(this);
    state =
        StateSet.stateIn(this) as _Page3State?; // uses _statefulStates[widget];

    state = StateSet.stateOf<Page3>()
        as _Page3State?; // uses _stateWidgets[_type<T>()];
    state =
        StateSet.of<Page3, _Page3State>(); // uses _stateWidgets[_type<T>()];
    state = StateSet.to<_Page3State>(); // uses _setStates[_type<T>()];

    state?.count++;

    /// Call the State object's setState() function
    StateSet.setStateOf(this, () {});
    // in the extension StateMapStatefulWidgetExtension on StatefulWidget
    setState(() {});
    StateSet.refreshState(this); // uses setStateOf(widget, () {});
    // in the extension StateMapStatefulWidgetExtension on StatefulWidget
    refresh();
    // in the extension StateMapStatefulWidgetExtension on StatefulWidget
    rebuild();
    // in the extension StateMapStatefulWidgetExtension on StatefulWidget
    notifyListeners();
    StateSet.rebuildState(this); // uses setStateOf(widget, () {});
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }
}

/// Demonstrates accessing the 'first' SetState object.
class _Page3State extends _PageState<Page3> {
  //
  @override
  Widget build(BuildContext context) => buildPage3(
        count: count,
        newKey: () {
          final firstState = StateSet.root;
          firstState?.setState(() {});
        },
        counter: widget.onPressed,
        page1counter: () {
          const Page1().onPressed();
        },
        page2counter: () {
          const Page2().onPressed();
        },
      );
}

Widget buildPage1({
  int count = 0,
  required void Function() counter,
}) =>
    BuildPage(
      label: '1',
      count: count,
      counter: counter,
      row: (BuildContext context) => [
        const SizedBox(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const Page2(),
              ),
            );
          },
          child: const Text(
            'Page 2',
          ),
        ),
      ],
    );

Widget buildPage2({
  int count = 0,
  required void Function() counter,
  required void Function() page1counter,
}) =>
    BuildPage(
      label: '2',
      count: count,
      counter: counter,
      row: (BuildContext context) => [
        ElevatedButton(
          style: flatButtonStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Page 1',
          ),
        ),
        ElevatedButton(
          style: flatButtonStyle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const Page3(),
              ),
            );
          },
          child: const Text(
            'Page 3',
          ),
        ),
      ],
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          style: flatButtonStyle,
          onPressed: page1counter,
          child: const Text('Page 1 Counter'),
        ),
      ],
    );

Widget buildPage3({
  int count = 0,
  required void Function() counter,
  required void Function() newKey,
  required void Function() page1counter,
  required void Function() page2counter,
}) =>
    BuildPage(
      label: '3',
      count: count,
      counter: counter,
      column: (BuildContext context) => [
        ElevatedButton(
          onPressed: newKey,
          child: const Text('New Key for Page 1'),
        ),
      ],
      row: (BuildContext context) => [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
              ..pop()
              ..pop();
          },
          child: const Text('Page 1'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Page 2'),
        ),
      ],
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: page1counter,
          child: const Text('Page 1 Counter'),
        ),
        ElevatedButton(
          onPressed: page2counter,
          child: const Text('Page 2 Counter'),
        ),
      ],
    );

///
///
/// Standard Counter Screen
///
///
///
class BuildPage extends StatelessWidget {
  const BuildPage({
    Key? key,
    required this.label,
    required this.count,
    required this.counter,
    this.column,
    required this.row,
    this.persistentFooterButtons,
  }) : super(key: key);

  final String label;
  final int count;
  final void Function() counter;
  final List<Widget> Function(BuildContext context)? column;
  final List<Widget> Function(BuildContext context) row;
  final List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('StateSet Mixin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text("You're on page:"),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 48),
                ),
              ]),
              Column(children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    'You have pushed the button this many times:',
                  ),
                ),
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: row(context),
                ),
              ),
              if (column == null)
                const SizedBox()
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: column!(context),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: counter,
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: persistentFooterButtons,
      );
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

/// This class contains a counter.
abstract class _PageState<T extends StatefulWidget> extends State<T>
    with StateSet {
  // The common counter variable on all the 'Page' State objects.
  int count = 0;

  @override
  Widget build(BuildContext context);
}
