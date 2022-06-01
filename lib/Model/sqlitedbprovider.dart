// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor(); // int

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor(); // int a;
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
    print('Creating Database......');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "newsfeed.db");
    print('Database Done......');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('Book Mark Table Created.....');
    await db.execute('''
          CREATE TABLE bookmark (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            link TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL
          )
          ''');
    print('User Table Created.....');
    await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )
          ''');
    print('Trending Table Created.....');
    await db.execute('''
          CREATE TABLE trending (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            link TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL
          )
          ''');
    print('Intrest Table Created.....');
    await db.execute('''
          CREATE TABLE intrest (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            link TEXT NOT NULL
          )
          ''');

    print('Feed Table Created.....');
    await db.execute('''
          CREATE TABLE feed (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            link TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL
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
    int updateCount =
        await db!.update('bookmark', row, where: 'id = ?', whereArgs: [id]);
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

  getSingleUser(String email, String password) async {
    Database? db = await instance.database;
    return await db!.rawQuery(
        'SELECT * FROM user WHERE email=? AND password=?', [email, password]);
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

  //___________________________________________INTREST FUNCTION
  Future<int>? insertIntrest(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('intrest', row);
  }

  isAvailableIntrest(String title, String link) async {
    print('Calling....');
    Database? db = await instance.database;
    int? count = Sqflite.firstIntValue(await db!.rawQuery(
        'SELECT COUNT(*) FROM intrest WHERE title =? AND link=?',
        [title, link]));
    // ignore: avoid_print
    if (count! > 0) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: avoid_types_as_parameter_names
  deleteIntrest(String title, String link) async {
    print('Calling....');
    Database? db = await instance.database;
    return await db?.delete('intrest', where: 'title = ?', whereArgs: [title]);
  }

  getAllIntrestRows() async {
    Database? db = await instance.database;
    return await db!.query('intrest');
  }

  clearIntrest() async {
    print('Delete All Intrest.......');
    Database? db = await instance.database;
    return await db!.rawQuery('delete from intrest');

  }

  //____________________________________________________________FUNCTION FOR FEED

  Future<int> insertFeed(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('feed', row);
  }

  Future<List<Map<String, dynamic>>> allFeeds() async {
    Database? db = await instance.database;
    return await db!.query('feed',orderBy :'date DESC',);
  }


  Future<int> getSingleFeed(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('feed', row);
  }

  clearFeed() async {
    print('Delete All Feeds.......');
    Database? db = await instance.database;
    return await db!.rawQuery('delete from feed');

  }
}
