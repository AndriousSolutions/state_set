import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  //
  const MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with StateSet {
  /// Key identifies the widget. New key? New widget!
  /// Demonstrates how to explicitly 're-create' a State object
  Key _homeKey = UniqueKey();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(key: _homeKey),
      );

  @override
  void setState(VoidCallback fn) {
    /// Key identifies the widget. New key? New widget!
    _homeKey = UniqueKey();
    super.setState(fn);
  }
}

class MyHomePage extends StatefulWidget {
  //
  const MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// The home page for this app.
class _MyHomePageState extends State<MyHomePage> with StateSet {
  //
  _MyHomePageState() : super() {
    /// Explicitly provide the 'type' of its State object.
    /// We're in the Stat object's constructor and so it's not ready yet
    /// but you do have the type.
    bloc = _CounterBloc<_MyHomePageState>();
  }
  _CounterBloc bloc;

  @override
  void initState() {
    super.initState();

    /// Supply the State object to the BLoC
    /// Now both the State object and its widget is ready at this point.
    bloc.initState();
  }

  @override
  void dispose() {
    // You should clean up after yourself.
    bloc.dispose();
    super.dispose();
  }

  /// Supply a means to access its bloc
  void onPressed() => bloc.onPressed();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${bloc.data}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const _SecondPage()));
            },
            child: const Text(
              'Second Page',
            ),
          ),
        ],
      );
}

/// The second page displayed in this app.
class _SecondPage extends StatefulWidget {
  //
  const _SecondPage({Key key}) : super(key: key);

  /// Alternatively, you can use the 'of' function and search by StatefulWidget.
//   _SecondPage({Key key}) : homeState = StateSet.of<MyHomePage>(), super(key: key);
//   final _MyHomePageState homeState;

  @override
  State createState() => _SecondPageState();
}

class _SecondPageState extends State<_SecondPage> with StateSet {
  /// _MyHomePageState has been instantiated and so is available at this point.
  _SecondPageState()
      : homeState = StateSet.to<_MyHomePageState>(),
        super();
  _SecondPageBloc bloc;
  _MyHomePageState homeState;

  @override
  void initState() {
    super.initState();

    /// Instead of bloc.initState(), you can just instantiate in initState().
    /// Supply the State object to the BLoC
    bloc = _SecondPageBloc<_SecondPageState>();
  }

  @override
  void dispose() {
    // You should clean up after yourself.
    bloc.dispose();
    homeState = null;
    super.dispose();
  }

  // Supply a means to access its bloc
  void onPressed() => bloc.onPressed();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("You're on the Second Page"),
              const Text('You have pushed the button this many times:'),
              Text(
                '${bloc.data}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: bloc.onPressed,
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            onPressed: homeState?.onPressed,
            child: const Text('Home Page Counter'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Home Page',
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const _ThirdPage()));
            },
            child: const Text(
              'Third Page',
            ),
          ),
        ],
      );
}

class _ThirdPage extends StatefulWidget {
  const _ThirdPage({Key key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

/// Demonstrates accessing the 'first' SetState object.
class _ThirdPageState extends State<_ThirdPage> with StateSet {
  /// Again, at the point, State object, _SecondPageState, is available.
  _ThirdPageState()
      : secondState = StateSet.to<_SecondPageState>(),
        super() {
    /// The State object, _ThirdPageState, is not instantiated just yet, but you've the type.
    bloc = _ThirdPageBloc<_ThirdPageState>();
    // Retrieve a specified State object.
    homeState = StateSet.to<_MyHomePageState>();
    // Retrieve the very 'first' State object!
    appState = StateSet.root;
  }
  _SecondPageState secondState;
  _ThirdPageBloc bloc;
  _MyHomePageState homeState;
  StateSet appState;

  @override
  void initState() {
    super.initState();

    /// This BLoC has a getter to retrieve the State object when needed (and likely available).
    // /// Supply the State object to the BLoC
    // bloc.initState();
  }

  @override
  void dispose() {
    // You should clean up after yourself.
    bloc.dispose();
    secondState = null;
    homeState = null;
    super.dispose();
  }

  // Supply a means to externally access this State objects functionality.
  void onPressed() => bloc.onPressed();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("You're on the Third page."),
              const Text('You have pushed the button this many times:'),
              Text(
                '${bloc.data}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            onPressed: homeState?.onPressed,
            child: const Text('Home Page Counter'),
          ),
          RaisedButton(
            onPressed: secondState?.onPressed,
            child: const Text('Second Page Counter'),
          ),
          RaisedButton(
            onPressed: () {
              appState?.setState(() {});
            },
            child: const Text('Home Page New Key'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Text('Home Page'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Second Page'),
          ),
        ],
      );
}

class _SecondPageBloc<T extends State> extends _CounterBloc<T> {
  /// Demonstrating how to extend the class, _CounterBloc
}

/// Retain a State object by knowing the type you're looking for.
class _ThirdPageBloc<T extends State> extends _CounterBloc<T> {
  /// POWERFUL: You can override the field with a getter.
  /// As a getter, you don't have to instantiate until needed (and available).
  @override
  T get state => StateSet.to<T>();
}

class _CounterBloc<T extends State> extends StateBLoC<T> {
  /// The 'data' is a lone integer.
  int _counter = 0;

  /// Getter to safely access the data.
  int get data => _counter;

  void onPressed() => setState(() {
        _counter++;
      });
}
