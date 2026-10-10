import 'package:flutter_test/flutter_test.dart';

import 'package:ambulance_app/main.dart';

void main() {
  testWidgets('shows the ambulance login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AmbulanceApp());

    expect(find.text('Emergency Ambulance'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
