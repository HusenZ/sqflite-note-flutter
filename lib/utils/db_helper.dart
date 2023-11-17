import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_notekeeper/model/note_model.dart';

class DBHelper {
  static final DBHelper _dataBaseHelper = DBHelper._();
  static Database? _database;
  DBHelper._();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  factory DBHelper() {
    return _dataBaseHelper;
  }

  Future<Database> get dataBase async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/notes.db';

    return openDatabase(path, version: 2, onCreate: _creatDB);
  }

  void _creatDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //Fetch operation
  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database db = await dataBase;

    // var result =
    // await db.rawQuery('SELECT * FORM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //Insert operation
  Future<int> insertNote(Note note) async {
    Database db = await dataBase;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //Update operation
  Future<int> updateNote(Note note) async {
    var db = await dataBase;
    var result = await db.update(
      noteTable,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
    return result;
  }

  //Get number of note objects in the database
  Future<int> getCount() async {
    Database db = await dataBase;
    List<Map<String, dynamic>> x =
        await db.query('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  //Delete operation
  Future<int> deleteNote(int id) async {
    var db = await dataBase;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  //get the map list
  Future<List<Note>> getNote() async {
    var noteMapList = await getNotesMapList();
    List<Note> noteList = [];

    for (var noteMap in noteMapList) {
      noteList.add(Note.fromMap(noteMap));
    }

    return noteList;
  }
}
