import 'package:flutter/material.dart';
import 'Mainpage/homepage.dart';
import 'package:splashscreen/splashscreen.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme : ThemeData(fontFamily: 'Roboto', ),
      home: SplashScreenCheckinMango(),
    );
  }
}

class SplashScreenCheckinMango extends StatelessWidget{
  Widget build(BuildContext context){
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds:  Homepage(),
      backgroundColor: Colors.white,
      //image: Image.asset('assets/images/logo.png'),
      title: Text('Check-in Mango',style: TextStyle(fontSize: 40,color: Colors.grey[800],fontWeight: FontWeight.bold),),
      loaderColor: Colors.white,
      onClick: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()))
    );
  }
}
