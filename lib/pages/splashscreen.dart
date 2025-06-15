import 'package:app_berita/pages/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
       Navigator.push(context, MaterialPageRoute(builder: (c)=> Login()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/gnet_logoc.png", height: 150),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

}