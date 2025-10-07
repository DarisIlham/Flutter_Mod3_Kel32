import 'package:flutter/material.dart';
import 'widget/navigation.dart';

void main() {
	runApp(const CountryApp());
}

class CountryApp extends StatefulWidget {
	const CountryApp({super.key});

	@override
	CountryAppState createState() => CountryAppState();

	// Helper to find the nearest state from child widgets
	static CountryAppState? of(BuildContext context) =>
			context.findAncestorStateOfType<CountryAppState>();
}

class CountryAppState extends State<CountryApp> {
	bool _isDark = false;

	bool get isDark => _isDark;

	void toggleTheme() {
		setState(() {
			_isDark = !_isDark;
		});
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'ApiCountries Demo',
			debugShowCheckedModeBanner: false,
			theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
			darkTheme: ThemeData(brightness: Brightness.dark),
			themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
			home: const NavigationPage(),
		);
	}
}

//hitam

