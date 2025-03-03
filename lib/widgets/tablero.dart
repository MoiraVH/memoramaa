import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:memorama/config/config.dart';
import 'package:flip_card/flip_card.dart';
import 'package:memorama/widgets/parrilla.dart';

class Tablero extends StatefulWidget {
  final Level? level;
  const Tablero(this.level, {Key? key}) : super(key: key);

  @override
  _TableroState createState() => _TableroState();
}

class _TableroState extends State<Tablero> with AfterLayoutMixin<Tablero>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level: ${widget.level?.name}"
        ),
      ),
      body: Parrilla(widget.level),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    throw UnimplementedError();
  }
}
