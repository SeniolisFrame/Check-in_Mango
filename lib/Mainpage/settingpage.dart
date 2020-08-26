import 'dart:async';

import 'objectClass/bluetoothFucntion.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'objectClass/Data.dart';
import 'material/Material.dart';

class  Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}
class _SettingState extends State<Setting> with BluetoothFuction{
  DeviceBlue dblue;
  @override
  void initState() {
    initPlatformState().then((_) => 
      initPlatformStateBlue().then((_) {
        refreshState();
        connect();
        } ));
    super.initState();
  }
  refreshState() async {
    setState(() {
      device = dblue.printer;
      deviceblue = dblue.bluetoothblue;
      connection = dblue.connection;
      devices= devices;
      device = device;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context).settings.arguments!=null){
       dblue = ModalRoute.of(context).settings.arguments;
    }
    return WillPopScope(
    onWillPop: ()=>
    Navigator.pushAndRemoveUntil( context,MaterialPageRoute(
      builder:(context) => Homepage(),
      settings: RouteSettings( arguments: DeviceBlue(device,deviceblue,bluetooth,connection)
      )),
      (Route<dynamic> route) => false),
    child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          leading: BackButton(
              onPressed: () => Navigator.pushAndRemoveUntil( context,MaterialPageRoute(
                builder:(context) => Homepage(),
                settings: RouteSettings( arguments: DeviceBlue(device,deviceblue,bluetooth,connection)
                )),
                (Route<dynamic> route) => false), 
            ),
            backgroundColor: appbarColor,
            centerTitle: true,
            title: Text('Setting',style: TextStyle(fontSize: 23,color: Colors.white),),
          ),
      body: devices.length==0 ? Center(child: Text('Don\'t Open Bluetooth ',style: TextStyle(fontSize: 18) ),):
      ListView.separated(
        separatorBuilder: (context, index) => Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey[400],),
        itemCount: devices.length+deviceblues.length+4,
        itemBuilder: (BuildContext context,int indexs){
          int indexPrinter = indexs-(deviceblues.length+3);
          int index = indexs-1;
          if(index==-1) 
            return Padding(
              padding: EdgeInsets.only(top:37,left:29,bottom: 6),
              child: Text('Weighing scale',style: TextStyle( fontSize: 15 ),),
              );
          if(index > -1 && index < deviceblues.length)
            return FlatButton(
              onPressed: (){
                setState(() {
                  deviceblue = deviceblues[index];
                });
              },
              child: Container(
                padding: EdgeInsets.only(top:17,left: 41,bottom: 17,right: 37),
                child: Row(
                  children : [
                    Text(deviceblues[index].name,style: TextStyle( fontSize: 13 )),
                    Spacer(),
                    deviceblues[index]!=deviceblue ?
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5)
                          ),
                          child: Container( height: 14,width: 14,),
                      ):
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5),
                          color: Colors.black
                          ),
                          child: Container( height: 14,width: 14,
                            alignment: Alignment.center,
                            child: Icon(Icons.check,color: Colors.white,size: 14,),
                        ),
                      )
                  ]
                )
              ),);

            if(indexPrinter==-2)
              return Padding(
              padding: EdgeInsets.only(top:37,left:29,bottom: 6),
              child: Text('Printer',style: TextStyle( fontSize: 15 ),),
              );
            if(indexPrinter==-1)
              return FlatButton(
              onPressed: (){
                setState(() {
                  device = null;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top:17,left: 41,bottom: 17,right: 37),
                child : Row(
                  children : [
                    Text('None',style: TextStyle( fontSize: 13 )),
                    Spacer(),
                      null != device ?
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5)
                          ),
                          child: Container( height: 14,width: 14,),
                      ):
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5),
                          color: Colors.black
                          ),
                          child: Container( height: 14,width: 14,
                            alignment: Alignment.center,
                            child: Icon(Icons.check,color: Colors.white,size: 14,),
                        ),
                      )
                  ]
                ),
              )
            );
            if(indexPrinter > -1 && indexPrinter < devices.length)
              return FlatButton(
              onPressed: (){
                setState(() {
                  device = devices[indexPrinter];
                });
              },
              child: Container(
                padding: EdgeInsets.only(top:17,left: 41,bottom: 17,right: 37),
                child: Row(
                  children : [
                    Text(devices[indexPrinter].name,style: TextStyle( fontSize: 13 )),
                    Spacer(),
                    devices[indexPrinter]!= device ?
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5)
                          ),
                          child: Container( height: 14,width: 14,),
                      ):
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black,width: 1.5),
                          color: Colors.black
                          ),
                          child: Container( height: 14,width: 14,
                            alignment: Alignment.center,
                            child: Icon(Icons.check,color: Colors.white,size: 14,),
                        ),
                      )
                  ]
                )
              ),
            );
              return Container();
        }
        ))
    );
  }
}