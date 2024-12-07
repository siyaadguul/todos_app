
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/model/tasks.dart';
import 'package:sqflite/sqflite.dart' as sql;
class TasksController with ChangeNotifier {
  List<Tasks> _tasks = [];

  List<Tasks> get tasks => _tasks;

  Future<sql.Database> initializeDatabase() async {
    return sql.openDatabase('tasks.db',
      version:1,
      onCreate: (db, version) {
        return db.execute(
            """CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT,category STRING, note TEXT,date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
      },);}

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db=await initializeDatabase();
    await db.insert('tasks', task, conflictAlgorithm: sql.ConflictAlgorithm.replace);


  }

getTasks()async{
    final db=await initializeDatabase();
    final data= await db.query("tasks");
    // print(jsonEncode(data));
    _tasks=data.map((tasks)=>Tasks.fromJson(tasks)).toList();
    notifyListeners();
}


  Future<void> deleteTask( int id) async {
    final db=await initializeDatabase();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

}