import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:memorama/db/victorias.dart';

class Sqlite {
  static Future<Database> db() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, "Victorias.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createDb(db);
      },
    );
  }

  static Future<void> createDb(Database db) async {
    const String sqlVictorias = """
      CREATE TABLE Victorias(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        resultado TEXT NOT NULL,
        nivel TEXT NOT NULL,
        movimientos INTEGER NOT NULL,
        tiempo TEXT NOT NULL,
        fechaHora TEXT NOT NULL
      )
    """;

    const String sqlDerrotas = """
      CREATE TABLE Derrotas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        resultado TEXT NOT NULL,
        nivel TEXT NOT NULL,
        movimientos INTEGER NOT NULL,
        tiempo TEXT NOT NULL,
        fechaHora TEXT NOT NULL
      )
    """;

    await db.execute(sqlVictorias);
    await db.execute(sqlDerrotas);
  }

  // Agregar victoria
  static Future<int> agregarVictoria(Victorias victoria) async {
    final Database database = await db();
    return await database.insert(
      "Victorias",
      victoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Agregar derrota
  static Future<int> agregarDerrota(Victorias derrota) async {
    final Database database = await db();
    return await database.insert(
      "Derrotas",
      derrota.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Limpiar victorias
  static Future<void> limpiarVictorias() async {
    final Database database = await db();
    await database.delete("Victorias");
  }

  // Limpiar derrotas
  static Future<void> limpiarDerrotas() async {
    final Database database = await db();
    await database.delete("Derrotas");
  }
}