import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/1/home_screen.dart';

import 'package:example/src/home/3/third_screen.dart';

import 'package:example/src/app/menu/app_menu.dart';

/// The second page displayed in this app.
class SecondScreen extends StatefulWidget {
  /// Singleton pattern. No need for multiple instances.
  factory SecondScreen({Key key}) => _this ??= SecondScreen._(key: key);
  const SecondScreen._({Key key}) : super(key: key);
  static SecondScreen _this;

  /// Access to the State object's functionality.
  void onPressed() {
    /// Always retrieve the 'latest' State object
    /// If a new Key was supplied to the Widget, it's recreate the State object.
    final _SecondScreenState state = StateSet.to<_SecondScreenState>();
    state?.onPressed();
  }

  @override
  State createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> with StateSet {
  /// A mutable data field.
  int _counter = 0;

  void onPressed() => _counter++;

  /// Raised buttons used in the popmenu and the screen itself.
  final List<RaisedButton> buttons = [];

  @override
  void initState() {
    super.initState();
    buttons.addAll([homeScreenCounter, homeScreen, thirdScreen]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
          actions: [
            AppMenu(buttons: buttons),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text('$_counter', style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(onPressed);
          },
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: buttons,
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

  RaisedButton get homeScreen => RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Home Screen'),
      );

  RaisedButton get thirdScreen => RaisedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => ThirdScreen()));
        },
        child: const Text('Third Screen'),
      );
}
