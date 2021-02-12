import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/app/menu/app_menu.dart';

import 'package:example/src/my_bloc.dart';

import 'package:example/src/home/2/second_page.dart';

class MyHomePage extends StatefulWidget {
  factory MyHomePage({Key key}) => _this ??= MyHomePage._(key: key);
  const MyHomePage._({Key key}) : super(key: key);
  static MyHomePage _this;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  // Supply a means to access its bloc
  void onPressed() {
    final _MyHomePageState state = StateSet.to<_MyHomePageState>();
    state.onPressed();
  }
}

/// The home page for this app.
class _MyHomePageState extends State<MyHomePage> with StateSet {
  //
  _MyHomePageState() : super() {
    bloc = CounterBloc<_MyHomePageState>();
  }

  CounterBloc bloc;

  @override
  void initState() {
    super.initState();

    /// Supply the State object to the BLoC
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
          title: const Text('Home Page: Example App #2'),
          actions: [
            AppMenu(),
          ],
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
                  builder: (BuildContext context) => SecondPage(),
                ),
              );
            },
            child: const Text(
              'Second Page',
            ),
          ),
        ],
      );
}
