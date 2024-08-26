// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.

import '../_test_imports.dart';

const _location = '========================== test_page1.dart';

Future<void> testPage3(WidgetTester tester) async {
  // Verify that counter has incremented.
  expect(find.text('0'), findsOneWidget, reason: _location);

  // 9 counts
  for (int cnt = 1; cnt <= 9; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  }

  expect(find.text('9'), findsOneWidget, reason: _location);

  var finder = find.byKey(const Key('Page 1 Counter'));

  expect(finder, findsOneWidget, reason: _location);

  await tester.tap(finder);
  await tester.pump();

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text('19'), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 2 Counter')));
  await tester.pump();

  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  expect(find.text('1'), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  finder = find.byKey(const Key('New Key'));

  expect(finder, findsOneWidget, reason: _location);

  await tester.tap(finder);
  await tester.pump();

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text('0'), findsOneWidget, reason: _location);
}
