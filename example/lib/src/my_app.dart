import 'package:flutter/material.dart';

import 'package:prefs/prefs.dart';

import 'package:state_set/state_set.dart';

import 'package:example/src/home/1/home_page.dart';

import 'package:example/src/home/1/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();

  /// static scope so to easily access this in the popup menu.
  void switchApps() {
    /// More often than not, you'll have access to the StatefulWidget.
    /// You can use the of() function to get its State object.
    _MyAppState appState = StateSet.of<MyApp>();

    /// If you know the State object's name, you use the to() function.
    /// Of course, you can only use it if the class is not private.
    appState = StateSet.to<_MyAppState>();

    /// Alternatively, since this is the app's first State object
    /// you can access it as the 'root' State object.
    appState = StateSet.root;
    appState?.switchApps();
    appState.setState(() {});
  }
}

/// Demonstrates how to explicitly 're-create' a State object
class _MyAppState extends State<MyApp> with StateSet {
  /// Key identifies the widget. New key? New widget!
  Key _homeKey = UniqueKey();
  bool _example01 = true;

  /// Toggle the bool variable
  void switchApps() {
    _example01 = !_example01;
    // Save the preference.
    Prefs.setBool('example', _example01);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<bool>(
          future: Prefs.getBoolF('example', true),
          initialData: true,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data
                  ? HomeScreen(key: _homeKey)
                  : MyHomePage(key: _homeKey);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );

  /// The build() function will be recalled.
  @override
  void setState(VoidCallback fn) {
    /// Setting a 'new key' will cause the State object to be re-created.
    _homeKey = UniqueKey();
    super.setState(fn);
  }
}
