import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/1/home_screen.dart';

import 'package:example/src/home/2/second_screen.dart';

import 'package:example/src/app/menu/app_menu.dart';

class ThirdScreen extends StatefulWidget {
  /// Singleton pattern. No need for multiple instances.
  factory ThirdScreen({Key key}) => _this ??= ThirdScreen._(key: key);
  const ThirdScreen._({Key key}) : super(key: key);
  static ThirdScreen _this;

  /// Access to the State object's functionality.
  void onPressed() {
    /// Always retrieve the 'latest' State object
    /// If a new Key was supplied to the Widget, it's recreate the State object.
    // Don't use ??= to save on performance. The State object may be recreated.
    final _ThirdScreenState state = StateSet.to<_ThirdScreenState>();
    state?.onPressed();
  }

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> with StateSet {
  /// A mutable data field.
  int _counter = 0;

  void onPressed() {
    setState(() {});
    _counter++;
  }

  /// Raised buttons used in the popupmenu and the screen itself.
  final List<RaisedButton> buttons = [];

  @override
  void initState() {
    super.initState();
    buttons.addAll([
      homeScreenCounter,
      secondScreenCounter,
      resetHome,
      homeScreen,
      secondScreen,
    ]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Third Screen'),
          actions: [
            AppMenu(buttons: buttons),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              homeScreenCounter,
              secondScreenCounter,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              resetHome,
              homeScreen,
              secondScreen,
            ],
          ),
        ],
      );

  RaisedButton get homeScreenCounter => RaisedButton(
        onPressed: () {
          final HomeScreen home = HomeScreen();
          home?.onPressed();

          /// Retrieves the State object of the specified StatefulWidget.
          final State state = StateSet.of<HomeScreen>();
          state?.setState(() {});
        },
        child: const Text('Home Counter'),
      );

  RaisedButton get secondScreenCounter => RaisedButton(
        onPressed: () {
          final second = SecondScreen();
          second?.onPressed();

          /// Of course, you could call setState() function in the
          /// onPressed() function above. This is merely to demonstrate
          /// you have access to an 'external' State object.
          final state = StateSet.of<SecondScreen>();
          state?.setState(() {});
        },
        child: const Text('Second Counter'),
      );

  RaisedButton get resetHome => RaisedButton(
        onPressed: () {
          /// Always returns the 'first' State object of the App.
          final State appState = StateSet.root;
          appState?.setState(() {});
        },
        child: const Text('Reset Home'),
      );

  RaisedButton get homeScreen => RaisedButton(
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        child: const Text('Home Screen'),
      );

  RaisedButton get secondScreen => RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Second Screen'),
      );
}
