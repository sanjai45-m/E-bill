import 'package:e_bill/providers/theme_provider.dart';
import 'package:e_bill/providers/vehicle_provider.dart';
import 'package:e_bill/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness:
            themeProvider.isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      home: SplashScreen(),
    );
  }
}
