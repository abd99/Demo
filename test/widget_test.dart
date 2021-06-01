import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphosis_flutter_demo/main.dart' as app;

void main() {
  group('Widget Tests', () {
    testWidgets('Testing main app widgets', (tester) async {
      await tester.pumpWidget(app.App());
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
      expect(find.byType(CupertinoSearchTextField), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
