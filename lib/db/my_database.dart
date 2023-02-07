import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:test_flutter_app/models/database_model.dart';

class NoteDB {
  NoteDB._init();
  static final instance = NoteDB._init();
  static Database? _database;

  //get_database
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB("note.db");
    return _database;
  }

  //create_DB
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        //types_of_fields
        const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        const textType = 'TEXT NOT NULL';

        await db.execute('''
                  CREATE TABLE $notesTable(
                    ${NoteFields.id} $idType,
                    ${NoteFields.title} $textType,
                    ${NoteFields.description} $textType
                  )
        ''');
      },
    );
  }

  //send_data
  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(notesTable, note.toJson());
    return note.copy(id: id);
  }

  //get_by_id
  Future<Note> readPost(int? id) async {
    final db = await instance.database;
    final maps = await db!.query(
      notesTable,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("Can't find id($id)!!!");
    }
  }

  //get_all
  Future<List<Note>> readAll() async {
    final db = await instance.database;
    final result = await db!.query(notesTable);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  //updage_note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return await db!.update(
      notesTable,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  //delete_note
  Future<int> deleteNote(int? id) async {
    final db = await instance.database;
    return await db!.delete(
      notesTable,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  //close_database
  Future closeDB() async {
    final db = await instance.database;

    db!.close();
  }
}
