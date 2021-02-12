import 'package:state_set/state_set.dart';

/// a static counter is necessary to retain the count
/// because <T extends SetState> does work with factory constructor
class SecondPageBloc<T extends StateSet> extends StateBLoC<T> {
  /// The 'data' is a lone integer.
  int _counter = 0;

  /// Getter to safely access the data.
  int get data => _counter;

  /// The generic function (Flutter API) called to manipulate the data.
  void onPressed() => setState(() {
        _counter++;
      });
}
