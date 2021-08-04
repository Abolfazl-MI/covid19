import 'package:covid19/screens/showCoountries.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.indigo,
      child: Center(
        child: Text(
          'Covid-19 infomation',
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
      ),
    ));
  }

  void _splashHandler() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ShowCountries()));
  }
}
