import 'package:flutter/material.dart';
import 'package:memorama/app/app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  runApp(const App());
}

