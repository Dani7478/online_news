import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor(); // int

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor(); // int a;
  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "newsfeed.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE bookmark (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            link TEXT NOT NULL,
            date TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE trending (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            link TEXT NOT NULL,
            date TEXT NOT NULL
          )
          ''');
  }

//_______________________________________BOOKMARK FUNCTION 
  Future<int> insertBookmark(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('bookmark', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsBookmark() async {
    Database? db = await instance.database;
    return await db!.query('bookmark');
  }

   void _update(Map<String, dynamic> row, int id) async {
    // row to update
    Database? db = await instance.database;
    int updateCount = await db!.update(
        'bookmark',
        row,
        where: 'id = ?',
        whereArgs: [id]);
  }

    Future<int> getSingleBookmark(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('bookmark', row);
  }

//_______________________________________USER FUNCTION 


  Future<int> insertUser(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('user', row);
  }

  getSingleUser(String email, String password) async 
  {
     Database? db = await instance.database;
     return await db!.rawQuery('SELECT * FROM user WHERE email=? AND password=?', [email, password]);
  }


  //_______________________________________BOOKMARK FUNCTION
  Future<int> insertTrending(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('trending', row);
  }

   clearTrending() async {
    Database? db = await instance.database;
    return await db!.rawQuery('delete from trending');
  }


  Future<List<Map<String, dynamic>>> getAllTrending() async {
    Database? db = await instance.database;
    return await db!.query('trending');
  }
 
}
