import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/1/home_page.dart';

import 'package:example/src/home/2/second_page.dart';

import 'package:example/src/home/3/third_bloc.dart';

class ThirdPage extends StatefulWidget {
  factory ThirdPage({Key key}) => _this ??= ThirdPage._(key: key);
  const ThirdPage._({Key key}) : super(key: key);
  static ThirdPage _this;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

/// Demonstrates accessing the 'first' SetState object.
class _ThirdPageState extends State<ThirdPage> with StateSet {
  _ThirdPageState() {
    // The corresponding Bloc
    bloc = ThirdPageBloc<_ThirdPageState>();
  }

  SecondPage second;
  ThirdPageBloc bloc;
  MyHomePage home;
  StateSet appState;

  @override
  void initState() {
    super.initState();

    /// Supply the State object to the BLoC
    bloc.initState();
    // Retrieve the very 'first' State object!
    appState = StateSet.root;
    // Retrieve a specified State object.
    home = MyHomePage();
    second = SecondPage();
  }

  @override
  void dispose() {
    // You should clean up after yourself.
    second = null;
    home = null;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: home?.onPressed,
                child: const Text('Home Page Counter'),
              ),
              RaisedButton(
                onPressed: second?.onPressed,
                child: const Text('Second Page Counter'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
          ),
        ],
      );
}
