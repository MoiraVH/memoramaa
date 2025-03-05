import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorama/App/app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Si es Windows, inicializa sqflite_common_ffi
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(App());
}
