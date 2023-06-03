// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

//dbhelper ini dibuat untuk
//membuat database, membuat tabel, proses insert, read, update dan delete

import 'package:captioner/model/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String tableCaption = 'tableHistory';
  final String columnId = 'id';
  final String columnCaption = 'caption';
  final String columnKeterangan = 'keterangan';
  final String columnImage = 'image';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek apakah database ada
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'history.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableCaption($columnId INTEGER PRIMARY KEY, "
        "$columnCaption TEXT,"
        "$columnKeterangan TEXT,"
        "$columnImage BLOB)";
    await db.execute(sql);
  }

  //insert ke database
  Future<int?> saveHistory(History history) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableCaption, history.toMap());
  }

  //read database
  Future<List?> getAllHistory() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableCaption, columns: [
      columnId,
      columnCaption,
      columnKeterangan,
      columnImage,
    ]);

    return result.toList();
  }

  //update database
  Future<int?> updateHistory(History history) async {
    var dbClient = await _db;
    return await dbClient!.update(tableCaption, history.toMap(),
        where: '$columnId = ?', whereArgs: [history.id]);
  }

  //hapus database
  Future<int?> deleteHistory(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableCaption, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> getcount(key) async {
    var dbclient = await _db;
    List<Map> maps = await dbclient!.query(tableCaption,
        columns: [
          columnId,
          columnCaption,
          columnKeterangan,
          columnImage,
        ],
        where: '$columnImage = ?',
        whereArgs: [key]);

    return maps.isNotEmpty;
  }
}
