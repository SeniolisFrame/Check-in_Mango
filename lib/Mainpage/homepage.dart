import 'dart:math';
import 'dart:typed_data';
import 'package:Check_in_mango/Mainpage/settingpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'objectClass/bluetoothFucntion.dart';
import 'weightslist.dart';
import 'material/Material.dart';
import 'databaseSQLite/Database.dart';
import 'objectClass/Data.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with BluetoothFuction {
  DB db;
  DBWEIGHT dbWEIGHT;
  List<Data> datalist;
  double currentweight=50.0;
  double alltotalweight;
  int lastid=0;
  List<int> lastIndex;
  //Max width image for printer
  //double maxWidthImage = 384; //for 57mm
  double maxWidthImage = 512; //for 80mm
  //Add Color
  List<String> colorRandom ;
  List<String> allColor = ['0xFF5733','0xC70039','0x900C3F','0x581845','0xF1C40F','0xF39C12','0xE67E22',
  '0x239B56','0x229954','0x138D75','0x17A589','0x2E86C1','0x2980B9','0x8E44AD','0x9B59B6','0xE74C3C',
  '0xC0392B','0x707B7C','0x2E4053','0xFA8072'];

  @override
  void initState() {
    super.initState();
      datalist = [];
      alltotalweight=0;
      db = DB();
      dbWEIGHT = DBWEIGHT();
      alltotalweight=0;
      colorRandom = allColor;
      //onLoading(context);
      _refreshData().then((_){
        if(connection==null)
          connectBlue();
        connect();
      }
    );
  }

  _refreshData() async {
   db.getData().then((imgs) {
      setState(() {
        datalist.clear();
        datalist.addAll(imgs);
        datalist.length==0 ? lastid = 0 : lastid = datalist[datalist.length-1].id+1;
        alltotalweight=0;
        imgs.forEach((element) {
          colorRandom.remove(element.color);
        });
        alltotalweight = datalist.fold(0, (previousValue, element)   => previousValue+=element.totalweight);
      });
    });
  }

  ImagePicker picker = ImagePicker();
  Future _getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery , maxWidth : maxWidthImage);
    final image = await pickedFile.readAsBytes();
    String stringimage = base64.encode(image);
    String color;
    if(colorRandom.length==0) colorRandom = allColor;
    color = colorRandom[Random().nextInt(colorRandom.length)];
    colorRandom.remove(color);
    Data dataimage = Data(lastid,stringimage,0,0,0,color);
    db.insert(dataimage);
    setState(() {
      datalist.add(dataimage);
      lastid = datalist[datalist.length-1].id+1;
    });
  }

  Future _removeImage(int index) async{
    int id = datalist[index].id;
    db.delete(id);
    dbWEIGHT.delete(id);
    colorRandom.add(datalist[index].color);
    setState(() {
      alltotalweight-=datalist[index].totalweight;
      datalist.removeAt(index);
    });
  }

  Future _sumWeight(int index) async{
    setState(() {
      datalist[index].currentweight = currentweight;
      datalist[index].totalweight += currentweight;
      datalist[index].round +=1;
      alltotalweight += currentweight;
    });
    db.update(datalist[index]);
    List temp = [];
    await dbWEIGHT.getWeightID(datalist[index].id).then((value) => temp.addAll(value));
    WeightList weightdata = WeightList(datalist[index].id,temp.length+1,currentweight);
    dbWEIGHT.insert(weightdata);
    printdata = PrinterList(datalist[index].image,[currentweight],datalist[index].round);
    onPrint(context);
    printFuction();
  }
  Future _confirmPrint(int index) async{
    convertData();
    currentweight = weightBluetooth;
    _sumWeight(index);
  }

  _printDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Container(
          width: 257,
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text("Confirm",style: TextStyle(fontSize: 20),),),
              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 10),
                child: Text("Do you want to print this image ?",style: TextStyle(fontSize: 13,color: Color(0xFF6E6E6E)),),),
              Padding(
                padding: EdgeInsets.only(bottom: 28),
                child: device==null ? 
                Text("Printer : None",style: TextStyle(fontSize: 10,color: Color(0xFF6E6E6E)),):
                Text("Printer : "+device.name,style: TextStyle(fontSize: 10,color: Color(0xFF6E6E6E)),),),
              Divider(height: 0.3,color: Color(0xFF6E6E6E),thickness: 0.3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(top: 15,bottom: 15,left: 25,right: 25),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child:
                    Text("Cancel",style: TextStyle(fontSize: 18),),),
                Container(height: 50, child: VerticalDivider(color: Color(0xFF6E6E6E),thickness: 0.3,)),
                FlatButton(
                  padding: EdgeInsets.only(top: 15,bottom: 15,left: 25,right: 25),
                  onPressed: () {
                    Navigator.pop(context); 
                    _confirmPrint(index);
                  },
                  child:
                    Text("Confirm",style: TextStyle(fontSize: 18),),),
                ],)
            ],  
          )
        ),
      )
    );
  } 

  removeDialog(int index,Color colorbox) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Container(
          width: 257,
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text("Remove",style: TextStyle(fontSize: 20),),),
              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 28),
                child: Text("Do you want to remove this image ?",style: TextStyle(fontSize: 13,color: Color(0xFF6E6E6E)),),),
              Divider(height: 0.3,color: Color(0xFF6E6E6E),thickness: 0.3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(top: 15,bottom: 15,left: 25,right: 25),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child:
                    Text("Cancel",style: TextStyle(fontSize: 18),),),
                Container(height: 50, child: VerticalDivider(color: Color(0xFF6E6E6E),thickness: 0.3,)),
                FlatButton(
                  padding: EdgeInsets.only(top: 15,bottom: 15,left: 25,right: 25),
                  onPressed: (){
                    Navigator.of(context).pop();
                      _removeImage(index);
                    },
                  child:
                    Text("Confirm",style: TextStyle(fontSize: 18),),),
                ],)
            ],  
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
     if(ModalRoute.of(context).settings.arguments!=null){
       DeviceBlue dblue = ModalRoute.of(context).settings.arguments;
        device = dblue.printer;
        deviceblue = dblue.bluetoothblue;
        connection = dblue.connection;
      }
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: 
          AppBar(
            backgroundColor: appbarColor,
            centerTitle: true,
            title: Text('Check-in Mango',style: TextStyle(fontFamily:'Abeezee', fontSize: 25,color: Colors.white),),
            actions: <Widget>[
            Padding( padding: EdgeInsets.only(top: 5,bottom: 5),
              child : FlatButton(
                onPressed: () {
                  disconnectBlue();
                  disconnect();
                  Navigator.push( context,MaterialPageRoute(
                          builder:(context) => Setting(),
                          settings: RouteSettings( arguments: DeviceBlue(device,deviceblue,bluetooth,connection)), 
                  ));
                  },
                child:Image.asset('assets/images/setting.png',height: 21,),shape: CircleBorder(),
              )
            )]
          ),
        body: (
          ListView.builder(
            itemCount: datalist.length+2,
            itemBuilder: (BuildContext context,int indexs) {
              int index = indexs-2;
              Color colorbox;
              if(index>=0) colorbox = stringToColor(datalist[index].color);
            if(index == -2)
              return Container(
                margin: EdgeInsets.only(top: 19,bottom: 24,left: 10,right: 10),
                padding:  EdgeInsets.only(top:39,bottom: 30),
                decoration: BoxDecoration( 
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [ shadowGrey() ],
                ),
                child: Center( 
                  child : Column(children: <Widget>[
                    Text("Total Weight :", style: TextStyle(fontSize: 18, color: Colors.black ), ),
                    Padding(padding: EdgeInsets.only(bottom:8) ),
                    Text(alltotalweight.abs().toStringAsFixed(3)+' kg.', style: TextStyle(fontSize: 36, color: Colors.black),),
                    ],
                  )
                ),
                );
            if(index == -1)
              return datalist.length==0 ? 
                Container(
                  height : MediaQuery.of(context).size.height*0.6,
                  child:Center(child:Text('No Image', style: TextStyle(fontSize: 18, color: Colors.black)))) 
                : Padding(
                  padding:EdgeInsets.only(bottom:17,left: 21) ,
                  child: Text('Summary', style: TextStyle(fontSize: 18, color: Colors.black)));
            return Padding( padding: EdgeInsets.only(left: 10,right: 10),
                child : Column(children: <Widget>[
                  Container(
                    decoration: BoxDecoration( 
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [ shadowGrey() ],
                    ),
                    child : Column( children: [
                      GestureDetector(
                        onTap : ()  { 
                          Navigator.push( context,MaterialPageRoute(
                          builder:(context) => Weightshowlist(),
                          settings: RouteSettings( arguments: WeightsListBlue(DeviceBlue(device,deviceblue,bluetooth,connection),datalist[index])), 
                          )
                        );},
                        child : Container(
                          padding: EdgeInsets.only(top : 10,left: 8,bottom: 8,right: 18),
                          decoration: BoxDecoration(
                            color: colorbox,
                            borderRadius: 
                              BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                              boxShadow:[ shadowGrey() ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[ 
                              Container(
                                width: 50,height:50,
                                decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,),
                                child: Center(child :
                                  Text(datalist[index].round.toString(),style: TextStyle(fontSize: 36,color: colorbox),),
                                )
                              ),
                              Container(),
                              Column( 
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Total/lot',style: TextStyle(fontSize: 14,color: Colors.white)),
                                  Text(datalist[index].totalweight.toStringAsFixed(3)+' kg.',style: TextStyle(fontSize: 24,color: Colors.white),),
                                ]
                              ),
                              Container(height: 50, child: VerticalDivider(color: Colors.white,thickness: 1,)),
                              Column( crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Current Weight',style: TextStyle(fontSize: 14,color: Colors.white),),
                                  Text(datalist[index].currentweight.toStringAsFixed(3)+' kg.',style: TextStyle(fontSize: 24,color: Colors.white),),
                                ]
                              ),
                            ]
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap : () async {
                          _printDialog(index);
                        } ,
                        child: Container(
                          padding: EdgeInsets.only(left: 20,right: 20,top:10),
                          child: Image.memory(base64Decode(datalist[index].image)),)
                        ),
                      Container(
                        alignment: Alignment.centerRight,
                          child : FittedBox( 
                            fit: BoxFit.cover ,
                            child: FlatButton(
                              onPressed : ()=> removeDialog(index,colorbox),
                              child:Image.asset('assets/images/trash.png',height: 21,),shape: CircleBorder()
                            )
                          )
                        ),
                    ])
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 21) )
                ]));
              },
            )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[800],
        child : FlatButton(
          onPressed : _getImage,
          child :Container(
            height: 50,
            alignment: Alignment.center,
            child: Text('Add new file',style: TextStyle(fontSize:15 ,color: Colors.white),)
          )
        ),
      )
    );
  }
}