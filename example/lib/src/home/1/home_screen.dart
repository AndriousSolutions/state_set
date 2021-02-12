import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/2/second_screen.dart';

import 'package:example/src/app/menu/app_menu.dart';

class HomeScreen extends StatefulWidget {
  /// Singleton pattern. No need for multiple instances.
  factory HomeScreen({Key key}) => _this ??= HomeScreen._(key: key);
  const HomeScreen._({Key key}) : super(key: key);
  static HomeScreen _this;

  void onPressed() {
    final _HomeScreenState state = StateSet.to<_HomeScreenState>();
    state.onPressed();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// The home page for this app.
class _HomeScreenState extends State<HomeScreen> with StateSet {
  _HomeScreenState(){
    // ignore: avoid_print
    print('>>>>>>>>>>>>>>>>>>>>>>>> State object, _HomeScreenState, created.');
  }
  /// A mutable data field.
  int _counter = 0;

  // void onPressed() => setState(() {
  //       _counter++;
  //     });

  void onPressed() => _counter++;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen: Example App #1'),
          actions: [
            AppMenu(buttons: [secondScreen]),
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
//          onPressed: onPressed,
          /// Wrapped in the setState() function
          onPressed: () => setState(onPressed),
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: <Widget>[
          secondScreen,
        ],
      );

  RaisedButton get secondScreen => RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SecondScreen(),
            ),
          );
        },
        child: const Text('Second Screen'),
      );
}
