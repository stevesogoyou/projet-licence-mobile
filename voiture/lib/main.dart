import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:voiture/authentification/loginForm.dart';
import 'package:voiture/authentification/secondWelcomePage.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/homepage/home.dart';
import 'package:voiture/bottomNav.dart';



void main() {
  runApp(const MyApp());
}
int _currentIndex = 0;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: TypingText(),
        ),

      ),
     
    );
  }
}

class TypingText extends StatefulWidget {
  const TypingText({super.key});

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> with TickerProviderStateMixin {
  late AnimationController _controller;
  int _index = 0;
  //late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    Timer.periodic(const Duration(milliseconds: 170), (timer) async {

        if (_index < "GEAR of TOGO".length) {
          _controller.forward();
          _index++;
          setState(() {});
        } else {
          timer.cancel();
          await Hive.initFlutter();
          Box box = await Hive.openBox('settings');
          print(Hive.openBox('settings'));
          print("Hive =");
          if(box.get('user') == null)
            {
              navigateToBoard(context, LoginForm(type: AuthType.login));
            }else
          navigateToBoard(context, secondPage());

        }

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text("GEAR of TOGO".substring(0, _index),
            style: GoogleFonts.kalam(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ));
      },
    );
  }
}