// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curaos/main.dart';
import 'package:curaos/pages/login/login_widget.dart';

void main() {
  testWidgets('App starts at login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CuraOSApp()));

    // Verify that our app starts and shows the Login screen.
    // (We look for the 'Entrar' button or 'E-mail' text which are part of our Login UI)
    expect(find.text('Entrar'), findsOneWidget);
  });
}
