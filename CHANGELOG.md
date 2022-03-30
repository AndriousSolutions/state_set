
## 3.3.1
 March 30, 2022
- Implement void activate() with _addThisState();
- sdk: ">=2.16.1 <3.0.0"

## 3.3.0
 January 06, 2022
- Changed  Map<Type, Type> _stateWidgets to Map<Type, StateSet> _stateWidgets
- _stateWidgets.isEmpty ? null : _stateWidgets.value
- StateSet._stateOf(this); to StateSet.stateIn(this);
- void deactivate() { /// In case of 'hot reload' and State object is re-created.
- Introduced example app
- sdk: ">=2.15.0 <3.0.0"

## 3.2.0
 July 29, 2021
- StateSet? stateOf(); bool setStateOf(VoidCallback fn) for extension on StatefulWidget

## 3.1.0
 July 16, 2021
- Retrieve State object used by the specified StatefulWidget object

## 3.0.1
 June 23, 2021
- Deprecated StateSetWidget. Proven insufficient.

## 3.0.0
 April 09, 2021
- Null Safety
- Introduces mixin, StateSetWidget

## 2.2.0
 February 27, 2021
- Introduce notifyListeners(), notifyClients()

## 2.1.0+2
 February 25, 2021
- Introduced _SetStateInheritedWidget
- flutter format .

## 2.0.0
 February 14, 2021
- StateBloc takes in Type of StatefulWidget and not State

## 1.0.0+7
 February 13, 2021
- Description in pubspec.yaml
- Rename _SecondPageState to _SecondScreenState
- Updated README.md file

## 1.0.0
 February 12, 2021
- Removed ?. operator
- Add print() to State object
- Updated README.md file
- Initial publication of the app

## 0.1.0
 February 11, 2021
- Initial commit