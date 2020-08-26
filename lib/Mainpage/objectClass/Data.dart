import 'package:blue_thermal_printer/blue_thermal_printer.dart' as ptbl;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as srbl;

class Data {
  int id;
  String image;
  double totalweight;
  double currentweight;
  int round;
  String color;
 
  Data(this.id, this.image, this.totalweight,this.currentweight,this.round,this.color);
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'image': image,
      'totalweight' : totalweight,
      'currentweight' : currentweight,
      'round' : round,
      'color' : color,
    };
    return map;
  }
 
  Data.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    image = map['image'];
    totalweight = map['totalweight'];
    currentweight = map['currentweight'];
    round = map['round'];
    color = map['color'];
  }
}

class WeightList {
  int id;
  int indexs;
  double weight;
 
  WeightList(this.id,this.indexs,this.weight);
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'indexs': indexs,
      'weight' : weight,
    };
    return map;
  }
 
  WeightList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    indexs = map['indexs'];
    weight = map['weight'];
  }
}


class PrinterList {
  String dataImage ;
  List<double> weight;
  int round;
  bool printAll;
  PrinterList(this.dataImage,this.weight,this.round,[this.printAll=false]);
}

class DeviceBlue {
  ptbl.BluetoothDevice printer;
  ptbl.BlueThermalPrinter bluetooth;
  srbl.BluetoothDevice bluetoothblue;
  srbl.BluetoothConnection connection;
  DeviceBlue(this.printer,this.bluetoothblue,this.bluetooth,this.connection);
}

class WeightsListBlue {
  DeviceBlue  dBlue;
  Data data;
  WeightsListBlue(this.dBlue,this.data);
}