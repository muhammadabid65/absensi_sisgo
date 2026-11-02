// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_pertama/main.dart';

void main() {
  testWidgets('login opens the attendance home', (WidgetTester tester) async {
    await tester.pumpWidget(const SisgoApp());
    expect(find.text('SISGO'), findsWidgets);
    expect(find.text('Masuk'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'nadia@sisgo.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'sisgo123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Selamat pagi, Nadia'), findsOneWidget);
    expect(find.text('Belum check-in'), findsOneWidget);
    expect(find.text('Foto check-in'), findsOneWidget);
  });

  testWidgets('attendance home renders on a phone viewport',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SisgoApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'nadia@sisgo.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'sisgo123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Selamat pagi, Nadia'), findsOneWidget);
    expect(find.text('Foto check-in'), findsOneWidget);
  });

  testWidgets('history filters absence records', (WidgetTester tester) async {
    await tester.pumpWidget(const SisgoApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'nadia@sisgo.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'sisgo123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Lihat riwayat'));
    await tester.tap(find.text('Lihat riwayat'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat kehadiran'), findsOneWidget);
    expect(find.text('Alpha'), findsNWidgets(2));

    final sickFilter = find.widgetWithText(ChoiceChip, 'Sakit');
    await tester.ensureVisible(sickFilter);
    await tester.tap(sickFilter);
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(sickFilter).selected, isTrue);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.textContaining('Istirahat dan pemulihan'), findsOneWidget);
    expect(find.textContaining('Tidak ada keterangan'), findsNothing);
  });
}
