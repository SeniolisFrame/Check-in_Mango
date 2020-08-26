import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'Data.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as ptbl;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as srbl;

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:image/image.dart'as imagelib;

class BluetoothFuction {
  PrinterList printdata;
  ptbl.BlueThermalPrinter bluetooth = ptbl.BlueThermalPrinter.instance;
  List<ptbl.BluetoothDevice> devices = [];
  ptbl.BluetoothDevice device;
  String pathImage;
  bool printstate = false;
  String dir;
  List<String> filename =[];

  Future initPlatformState()  async {
    List<ptbl.BluetoothDevice> deviceAll = [];
   try {
      deviceAll = await bluetooth.getBondedDevices();
      devices = deviceAll;
      print(devices.length);
    } on PlatformException {} 
  }

  connect() async {
    if (device == null) {
     print('no select Printer');
   } else {
       bluetooth.connect(device).then((_) {
            print('connected printer');
          }
      );
   }
 }
  disconnect() {
    bluetooth.disconnect();
  }
  
  Future printFuction() async {
    writeImage(printdata.dataImage).then((_)=>
    bluetooth.isConnected.then((isConnected) {
      Future.delayed(Duration(milliseconds:1000)).then((value) async {
      if (isConnected) {
        print('print');
        if(!printdata.printAll){
          int round = printdata.round;
          for(int i=0; i<filename.length;i++){
            String name = filename[i];
            bluetooth.printImage('$dir/$name');
            Future.delayed(Duration(microseconds: 500));
          }
          bluetooth.printLeftRight(' Basket','Weight',1);
          bluetooth.printLeftRight('  $round',printdata.weight[0].toStringAsFixed(3)+" kg.",1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
        } 
        else if(printdata.printAll){
           for(int i=0; i<filename.length;i++){
            String name = filename[i];
            bluetooth.printImage('$dir/$name');
            Future.delayed(Duration(microseconds: 500));
          }
          bluetooth.printNewLine();
          bluetooth.printLeftRight(' Times','Weight',1);
          for(int i = 1 ; i < printdata.weight.length+1 ; i++){
            bluetooth.printLeftRight('  $i',printdata.weight[i-1].toStringAsFixed(3)+'kg',1);
            Future.delayed(Duration(microseconds: 500));
          }
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          
        }
      } else {
      }
      filename = [];
    });}
    )
    );
  }
   writeImage(String image) async {
    int maxHeight = 200;
    imagelib.Image imageSplit = imagelib.decodeImage(base64.decode(image).toList());
    int x = 0, y = 0;
    int w = imageSplit.width , h = imageSplit.height;
    for(int i=0; i < (h/maxHeight).floor()+1;i++){
      filename.add('image_part$i');
    }
    List imageParts =[];
    for(int i=0; i < filename.length ;i++){
      if(h>maxHeight)
        imageParts.add(imagelib.encodePng(imagelib.copyCrop(imageSplit, x, y, w, maxHeight)));
      else
        imageParts.add(imagelib.encodePng(imagelib.copyCrop(imageSplit, x, y, w, h)));
      y += maxHeight;
      h -= maxHeight;
    }
    dir = (await getApplicationDocumentsDirectory()).path;
    for(int i=0; i<filename.length;i++){
      String name = filename[i];
      writeToFile(imageParts[i],'$dir/$name');
    }
  }

  Future writeToFile(data, String path) async {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
 }

 List<srbl.BluetoothDevice> deviceblues;
  srbl.BluetoothDevice deviceblue;
  srbl.FlutterBluetoothSerial bluetoothBlue = srbl.FlutterBluetoothSerial.instance;
  srbl.BluetoothConnection connection;
  String weightAndStatus;
  double weightBluetooth;
  String weightStatus;

  Future initPlatformStateBlue() async {
    List<srbl.BluetoothDevice> deviceAll = [];
    try {
     deviceAll =  await bluetoothBlue.getBondedDevices();
   } on PlatformException {}
  deviceblues = deviceAll;
  }
 connectBlue() async {
    if (deviceblue == null) {
      print('no select Device');
   } else {
    try {
      connection = await srbl.BluetoothConnection.toAddress(deviceblue.address);
      print('Connected to the device');
      connection.input.listen((Uint8List dataR) {
        weightAndStatus = ascii.decode(dataR);
    });
    }
    catch (exception) {
      print('Cannot connect, exception occured');
    }
   }
 }
  Future disconnectBlue() async {
    connection.close();
  }
  convertData() async{
    weightBluetooth = double.parse(weightAndStatus.substring(5,13));
  }
}