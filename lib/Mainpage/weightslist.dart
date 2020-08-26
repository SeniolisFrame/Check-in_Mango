import 'package:flutter/material.dart';
import 'material/Material.dart';
import 'databaseSQLite/Database.dart';
import 'objectClass/Data.dart';
import 'objectClass/bluetoothFucntion.dart';
import 'homepage.dart';

class Weightshowlist extends StatefulWidget {
  @override
  _WeightshowlistState createState() => _WeightshowlistState();
}

class _WeightshowlistState extends State<Weightshowlist> with BluetoothFuction {
  Data dataSelect;
  List<WeightList> weightlist=[];
  List<double> list;
  DBWEIGHT dbWEIGHT;

  @override
  void initState() {
    super.initState();
    dbWEIGHT = DBWEIGHT();
    delay().then((_) => connectBlue());
    //onLoading(context);
  }
  Future delay() async{
    Future.delayed(Duration(microseconds: 500));
  }

  refreshData(int id){
    dbWEIGHT.getWeightID(id).then((value) {
      setState(() {
        weightlist.clear();
        weightlist.addAll(value);
      });
    });
  }

  _printDialog(int index,bool printAll) {
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if(printAll) {
                      List<double> temp = [];
                      weightlist.forEach((element) { temp.add(element.weight);});
                      print(temp);
                      printdata = PrinterList(dataSelect.image,temp,0,true);
                    }
                    else 
                      printdata = PrinterList(dataSelect.image,[weightlist[index].weight],weightlist[index].indexs);
                    printFuction();
                    onPrint(context);
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
  Widget build(BuildContext context){
    if(ModalRoute.of(context).settings.arguments!=null){
      WeightsListBlue datablue = ModalRoute.of(context).settings.arguments;
      device = datablue.dBlue.printer;
      deviceblue = datablue.dBlue.bluetoothblue;
      connection = datablue.dBlue.connection;
      dataSelect = datablue.data;
    }
    refreshData(dataSelect.id);
    Color colorbox = stringToColor(dataSelect.color);
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
          title: Text('Check-in Mango',style: TextStyle(fontFamily:'Abeezee', fontSize: 25,color: Colors.white),),
        ),
      body: ( 
        Padding(padding: EdgeInsets.only(left:10,top: 30,right: 10,bottom: 60),
        child:Container(
          decoration: BoxDecoration( 
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
            boxShadow: [ shadowGrey() ],
          ),
          child: Center( 
            child :Column( 
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorbox,
                  borderRadius: 
                    BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Container(
                      width: 50,height: 50,
                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,),
                        child: Center(child :
                        Text(dataSelect.round.toString(),style: TextStyle(fontSize: 36,color: colorbox),),
                        )
                      ),
                      Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Text('Total/lot:',style: TextStyle(fontSize: 14,color: Colors.white)),
                        Text(dataSelect.totalweight.toStringAsFixed(3)+' kg.',style: TextStyle(fontSize: 25,color: Colors.white),),
                        ]
                      ),
                      OutlineButton(
                      onPressed: () => { _printDialog(0,true),},
                      textColor: Colors.white,
                      borderSide: BorderSide(color: Colors.white, width: 1.5, style: BorderStyle.solid),
                      child: Text('Print all',style: TextStyle(fontSize:14),),
                    ),
                  ]
                ),
              ),    
              Expanded(child:  weightlist.length == 0 ? Center(child: Text('No Data' ,style: TextStyle(fontSize: 18,color: colorbox),),):
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    indent: 10,
                    endIndent: 10,
                    height: 1,
                    color: Color.fromARGB(0xff, 0xC4, 0xC4,0xC4),
                  ),
                  itemCount: weightlist.length+1,
                  itemBuilder: (BuildContext context,int index){
                    if (index == weightlist.length)
                      return Container();
                    return FlatButton(
                      onPressed: () => _printDialog(index,false),
                      child: Container(
                      margin: EdgeInsets.only(left:20,right: 20,top: 17,bottom: 17),
                      child : Row(
                          children: <Widget>[
                            Text('ครั้งที่ : '+weightlist[index].indexs.toString(),style: TextStyle(fontSize: 14,color: Colors.black),),
                            Spacer(),
                            Text(weightlist[index].weight.toStringAsFixed(3)+' kg.',style: TextStyle(fontSize: 14,color: Colors.black),),
                          ],
                        ),)
                    );
                  }
                )
              ),
            ],
          )
        )
    ),)))
    );
  }
}