import 'package:flutter/material.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/1/home_page.dart';

import 'package:example/src/home/2/second_bloc.dart';

import 'package:example/src/home/3/third_page.dart';

/// The second page displayed in this app.
class SecondPage extends StatefulWidget {
  factory SecondPage({Key key}) => _this ??= SecondPage._(key: key);
  const SecondPage._({Key key}) : super(key: key);
  static SecondPage _this;

  @override
  State createState() => _SecondPageState();

  // Supply a means to access its bloc
  void onPressed() {
    final _SecondPageState state = StateSet.to<_SecondPageState>();
    state.onPressed();
  }
}

class _SecondPageState extends State<SecondPage> with StateSet {
  //
  SecondPageBloc bloc;
  MyHomePage home;

  @override
  void initState() {
    super.initState();

    /// Instead of bloc.initState(), you can just instantiate in initState().
    /// Supply the State object to the BLoC
    bloc = SecondPageBloc<_SecondPageState>();
    home = MyHomePage();
  }

  @override
  void dispose() {
    // You should clean up after yourself.
    bloc.dispose();
    home = null;
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
            onPressed: home?.onPressed,
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
                      builder: (BuildContext context) => ThirdPage()));
            },
            child: const Text(
              'Third Page',
            ),
          ),
        ],
      );
}
