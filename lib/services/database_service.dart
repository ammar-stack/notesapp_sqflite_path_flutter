import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_notesapp_sqflite_flutter/models/task.dart';

class DatabaseService {
  static Database? _db;
  final String tableName = 'tasks';
  final String idColumnName = 'id';
  final String contentColumnName = 'content';
  final String statusColumnName = 'status';
  //making sure that only one instance of database is created and performing several operations

  static final DatabaseService instance = DatabaseService._constructor();

  //creating a constructor which is private
  DatabaseService._constructor();

  //Checking if already created
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  //Creating function that creates our database
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath =
        join(databaseDirPath, "main_database.db"); //naming database
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $tableName(
        $idColumnName INTEGER PRIMARY KEY,
        $contentColumnName TEXT NOT NULL,
        $statusColumnName INTEGER NOT NULL  
        )
         ''');
      },
    );
    return database;
  }

  //creating a method to insert new values
  void addTask(String content) async {
    final db = await database;
    await db
        .insert(tableName, {contentColumnName: content, statusColumnName: 0});
  }

  //creating a method to read all task as model is already created to read data from database
  Future<List<Task>> getTask() async {
    final db = await database;
    final data = await db.query(tableName);
    List<Task> tasks = data
        .map((e) => Task(
            content: e['content'] as String,
            id: e['id'] as int,
            status: e['status'] as int))
        .toList();
    return tasks;
  }

  //function for updating data
  void updateTaskStatus(int id, int status) async{
    final db = await database;
    await db.update(tableName, {
      statusColumnName : status
    },
    where: 'id = ?',
    whereArgs: [id]);
  }

  //function for deleting a task
  void deleteTask(int id) async{
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id]
      );
  }
}
