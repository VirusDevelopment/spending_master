import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:expencetracker/models/expenceModel.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singaltone Object
  static Database _database;//Singaltone Object
  String expenceTable = 'expences';
  String colId = 'id';
  String colexpencedatetime = 'expencedatetime';
  String colcategory = 'category';
  String colpaymentMode = 'paymentMode';
  String amount = 'amount';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  FutureOr<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{debugPrint("initializeDatabase");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'expencetracker.db';
    var expencetrackerDatabase = openDatabase(path,version:1,onCreate : _createDb);
    return expencetrackerDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    debugPrint("_createDb");
      await db.execute('CREATE TABLE $expenceTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colexpencedatetime TEXT,'
        '$colpaymentMode INTEGER,'
        '$colcategory TEXT,'
        '$amount TEXT )');
  }

  // Get Data
  Future<List<Map<String,dynamic>>> getexpenceMap() async{
    Database db = await this.database;
    var result = await db.query(expenceTable,orderBy:'$colId ASC');
    return result;
  }
  // Insert Data
  Future<int> insertexpenceMap(ExpenceModel _expence) async{
    debugPrint("insertexpenceMap");
    Database db = await this.database;
    var result = await db.insert(expenceTable,_expence.toMap());
    return result;
  }
  // Update Data
  Future<int> updateexpenceMap(ExpenceModel _expence) async{
    Database db = await this.database;
    var result = await db.update(expenceTable,_expence.toMap(), where: '$colId = ?', whereArgs: [_expence.id]);
    return result;
  }
  // Delete Data
  Future<int> deleteexpenceMap(int id) async{
    Database db = await this.database;
    var result = await db.delete(expenceTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
  // getCount Data
  Future<int> getCountofExpenceMap() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT(*) FROM $expenceTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  // getCount DataList
  Future<List<ExpenceModel>> getexpenceList() async{
     var expencemapList = await getexpenceMap();
     int count = expencemapList.length;
     List<ExpenceModel> expenceList = List<ExpenceModel>();
     for(int i=0; i< count; i++){
       expenceList.add(ExpenceModel.fromMapObject(expencemapList[i]));
     }
     return  expenceList;
  }
}
