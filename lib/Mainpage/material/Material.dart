import 'dart:math';
import 'package:flutter/material.dart';
Color stringToColor (String color){
  Color _color = Color(int.parse(color)+0xFF000000);
  return _color;
}
BoxShadow shadowGrey (){
  return BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 1),
          );
}
Color appbarColor = Color(0xFF3A3A3A);
Color backgroundColor = Color(0xFFEFEFEF);
onPrint(dynamic context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:53,bottom: 13),
                  child: Text("Printed",style: TextStyle( fontSize: 20 ),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 53),
                  child:Image.asset('assets/images/ok.gif',height: 50,),
                )
                ],
              ),
            )
          );
        },
      );
  Future.delayed(Duration(seconds: 1)).then((_) => Navigator.pop(context));
}
  onLoading(dynamic context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:53,bottom: 13),
                  child: Text("Loading...",style: TextStyle( fontSize: 20 ),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 53),
                  child:Image.asset('assets/images/circle.gif',height: 50,),
                )
                ],
              ),
            )
          );
        },
      );
      Future.delayed(Duration(seconds: 1)).then((_) => Navigator.pop(context));
    }