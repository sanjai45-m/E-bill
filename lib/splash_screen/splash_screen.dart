import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:e_bill/view/e-ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: Column(children: [
      Center(child: LottieBuilder.asset("assets/icon/Animation - 1729668326988.json"),)
    ],), nextScreen: ETicketScreen()
    ,backgroundColor: Color(0xFF004EA3),splashIconSize: 300,);
  }
}
