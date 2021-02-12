import 'package:flutter/material.dart';

import 'package:app_popup_menu/app_popup_menu.dart';

import 'package:example/src/my_app.dart';

class AppMenu extends AppPopupMenu<String> {
  AppMenu({Key key, this.buttons}) : super(key: key);

  final List<RaisedButton> buttons;
  final Map<String, RaisedButton> menuButtons = {};

  @override
  ShapeBorder onShape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      );

  @override
  Offset onOffset() => const Offset(0, 45);

  @override
  List<String> onItems() {
    //
    final List<String> items = [];

    if (buttons != null) {
      for (final RaisedButton button in buttons) {
        final Text text = button.child;
        items.add(text.data);
        menuButtons[text.data] = button;
      }
    }
    items.addAll(['Switch Apps']);

    return items;
  }

  @override
  void onSelection(String value) {
    switch (value) {
      case 'Switch Apps':
        {
          /// Of course, setState() function could be included
          /// in the switchApps() function but this is just to
          /// demonstrate you've access to the SetState object.
          Navigator.popUntil(context, ModalRoute.withName('/'));
          const MyApp home = MyApp();
          home?.switchApps();
        }
        break;
      default:
        {
          /// Possibly a RaisedButton is selected.
          menuButtons[value]?.onPressed();
        }
        break;
    }
  }
}
