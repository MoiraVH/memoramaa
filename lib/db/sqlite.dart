import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as dataz;
import 'package:path/path.dart';
import 'package:memorama/db/victorias.dart';


class Sqlite {
  static Future<dataz.Database> db() async {
    final io
        .Directory appDocumentDir = await getApplicationDocumentsDirectory();
    String rute = join(appDocumentDir.path, "databases", "Victorias.db");

    return dataz.openDatabase(
      rute,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await createDb(db);
      },
    );
  }

  static Future<void> createDb(dataz.Database db) async {
    const String sqlVictorias = """
      create table Victorias(
        id integer primary key autoincrement not null,
        resultado text not null,
        nivel text not null,
        movimientos integer not null,
        tiempo text not null,
        fechaHora text not null
      )
    """;

    const String sqlDerrotas = """
      create table Derrotas(
        id integer primary key autoincrement not null,
        resultado text not null,
        nivel text not null,
        movimientos integer not null,
        tiempo text not null,
        fechaHora text not null
      )
    """;

    await db.execute(sqlVictorias);
    await db.execute(sqlDerrotas);
  }

  // Método para agregar una victoria
  static Future<int> agregarVictoria(Victorias victoria) async {
    final dataz.Database database = await db();
    return await database.insert(
      "Victorias",
      victoria.toMap(),
      conflictAlgorithm: dataz.ConflictAlgorithm.replace,
    );
  }

// Método para agregar una derrota
  static Future<int> agregarDerrota(Victorias derrota) async {
    final dataz.Database database = await db();
    return await database.insert(
      "Derrotas",
      derrota.toMap(),
      conflictAlgorithm: dataz.ConflictAlgorithm.replace,
    );
  }

  // Método para limpiar todas las victorias
  static Future<void> limpiarVictorias() async {
    final dataz.Database database = await db();
    await database.delete("Victorias");
  }

  // Método para limpiar todas las derrotas
  static Future<void> limpiarDerrotas() async {
    final dataz.Database database = await db();
    await database.delete("Derrotas");
  }
}

