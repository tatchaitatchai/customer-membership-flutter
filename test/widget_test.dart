import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:points_me/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PointsMeApp()));
    await tester.pumpAndSettle();

    expect(find.text('POINTS ME'), findsOneWidget);
  });
}
