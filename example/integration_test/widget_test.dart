// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.

import 'src/_test_imports.dart';

void main() => integrationTesting();

void integrationTesting() {
  //
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Runs before the testing begins
  setUp(() async {});

  /// Runs after EACH test or group
  tearDown(() {});

  /// Define a test. The TestWidgets function also provides a WidgetTester
  /// to work with. The WidgetTester allows you to build and interact
  /// with widgets in the test environment.
  testWidgets('testing example app', (WidgetTester tester) async {
    /// Flutter won’t automatically rebuild your widget in the test environment.
    /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
    await tester.pumpWidget(const MainApp());

    /// pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    await testPage1(tester);

    await testPage2(tester);

    await testPage3(tester);
  });
}
