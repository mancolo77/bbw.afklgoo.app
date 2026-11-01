import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_/screens/main_navigation_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget createTestWidget() {
    return const MaterialApp(
      home: MainNavigationScreen(),
    );
  }

  testWidgets('Navigation: verify exactly 3 navigation tabs and tab switching',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.items.length, equals(3));

    final navBarFinder = find.byType(BottomNavigationBar);
    expect(find.descendant(of: navBarFinder, matching: find.text('Handbook')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Knowledge Check')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('My Learning')), findsOneWidget);

    // Switch to Knowledge Check tab
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Knowledge Check')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Switch to My Learning tab
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('My Learning')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Switch back to Handbook
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Handbook')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });
}
