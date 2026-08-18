import 'package:flutter_test/flutter_test.dart';

import 'package:contact_management/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactManagementApp());

    // Verify the home screen loads
    expect(find.text('My Contacts'), findsOneWidget);
  });
}
