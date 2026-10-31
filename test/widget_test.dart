import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app_/main.dart';
import 'package:app_/providers/loyalty_provider.dart';
import 'package:app_/screens/main_navigation_screen.dart';
import 'package:app_/services/quiz_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => LoyaltyProvider(),
      child: const MaterialApp(
        home: MainNavigationScreen(),
      ),
    );
  }

  testWidgets('Navigation: verify exactly 4 navigation tabs and tab switching',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify exactly 4 BottomNavigationBar items
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.items.length, equals(4));

    expect(find.text('Квизы'), findsOneWidget);
    expect(find.text('Дейли'), findsOneWidget);
    expect(find.text('Награды'), findsOneWidget);
    expect(find.text('Профиль'), findsOneWidget);

    // Switch to Daily tab
    await tester.tap(find.text('Дейли'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Switch to Rewards tab
    await tester.tap(find.text('Награды'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Switch to Profile tab
    await tester.tap(find.text('Профиль'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Switch back to Quizzes tab
    await tester.tap(find.text('Квизы'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });

  final viewports = <String, Size>{
    'Compact Mobile (320x480)': const Size(320, 480),
    'Standard iPhone (390x844)': const Size(390, 844),
    'Modern Android (412x915)': const Size(412, 915),
    'Tablet Viewport (800x1280)': const Size(800, 1280),
  };

  for (final entry in viewports.entries) {
    testWidgets('RenderFlex: zero overflow on ${entry.key} across all 4 tabs',
        (WidgetTester tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Check Daily Tab
      await tester.tap(find.text('Дейли'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Check Rewards Tab
      await tester.tap(find.text('Награды'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Check Profile Tab
      await tester.tap(find.text('Профиль'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Return to Quizzes Tab
      await tester.tap(find.text('Квизы'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('JSON: content from assets/quiz_data.json loads successfully',
      (WidgetTester tester) async {
    final bundle = await QuizDataService.loadQuizData();
    expect(bundle.appName, isNotEmpty);
    expect(bundle.categories, isNotEmpty);
    expect(bundle.ranks, isNotEmpty);
    expect(bundle.dailyChallenges, isNotEmpty);
    expect(bundle.rewards, isNotEmpty);
  });

  testWidgets('Application: Verify MainApp builds and initializes correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 3));
  });
}
