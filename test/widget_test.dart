import 'package:flutter/cupertino.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

// ignore: avoid_relative_lib_imports
import '../example/lib/main.dart';

void main() => testMyApp();

/// Also called in package's own testing file, test/widget_test.dart
void testMyApp() {
  ///
  final app = MainApp(key: UniqueKey());

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Registers a function to be run once after all tests.
  /// Be sure the close the app after all the testing.
  tearDownAll(() {});

  ///
  testWidgets('test state_extended', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// Flutter won’t automatically rebuild your widget in the test environment.
    /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
    /// pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();
  });
}
