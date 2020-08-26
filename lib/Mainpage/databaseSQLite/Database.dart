import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../objectClass/Data.dart';

class DB {
  static Database _db;
  static const String ID = 'id';
  static const String IMAGE = 'image';
  static const String TOTALWEIGHT = 'totalweight';
  static const String CURRENTWEIGHT = 'currentweight';
  static const String ROUND = 'round';
  static const String COLOR = 'color';
  static const String TABLE = 'DataTable';
  static const String DB_NAME = 'data.db';

 
  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $IMAGE TEXT, $TOTALWEIGHT DOUBLE, $CURRENTWEIGHT DOUBLE, $ROUND INTEGER , $COLOR TEXT)");
  }
 
  Future insert(Data data) async {
    var dbClient = await db;
    await dbClient.insert(TABLE, data.toMap());
  }

  Future delete(int id) async {
    var dbClient = await db;
    await dbClient.delete(TABLE, where: 'id = ?' ,whereArgs: [id]);
  }

  Future update(Data data) async {
    var dbClient = await db;
    await dbClient.update(TABLE,data.toMap(),where: "id = ?",whereArgs: [data.id],
    );
  }

  Future<List<Data>> getData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, IMAGE, TOTALWEIGHT, CURRENTWEIGHT, ROUND, COLOR],orderBy: "ID ASC");
    List<Data> datalist = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        datalist.add(Data.fromMap(maps[i]));
      }
    }
    return datalist;
  }
  
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

class DBWEIGHT {
  static Database _db;
  static const String ID = 'id';
  static const String INDEXS = 'indexs';
  static const String WEIGHT = 'weight';
  static const String WEIGHTTABLE = 'WeightTable';
  static const String DB_WEIGHTLIST = 'dataweight.db';
 
  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_WEIGHTLIST);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $WEIGHTTABLE ($ID INTEGER, $INDEXS INTEGER, $WEIGHT DOUBLE)");
  }
 
  Future insert(WeightList data) async {
    var dbClient = await db;
    await dbClient.insert(WEIGHTTABLE, data.toMap());
  }

  Future delete(int id) async {
    var dbClient = await db;
    await dbClient.delete(WEIGHTTABLE, where: 'id = ?' ,whereArgs: [id]);
  }

  Future update(WeightList data) async {
    var dbClient = await db;
    await dbClient.update(WEIGHTTABLE,data.toMap(),where: "id = ?",whereArgs: [data.id],);
  }
  
  /*Future<List<WeightList>> getWeight() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(WEIGHTTABLE, columns: [ID, INDEXS, WEIGHT],orderBy: "id ASC");
    List<WeightList> weightlist = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        weightlist.add(WeightList.fromMap(maps[i]));
      }
    }
    return weightlist;
  }*/

  Future<List<WeightList>> getWeightID(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(WEIGHTTABLE, columns: [INDEXS, WEIGHT],where:'id = ?',whereArgs: [id],orderBy: "id ASC" );
    List<WeightList> weightlist = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        weightlist.add(WeightList.fromMap(maps[i]));
      }
    }
    return weightlist;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}