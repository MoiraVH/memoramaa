import 'package:flutter/material.dart';
import 'dart:io';

import 'package:memorama/widgets/botonera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memo"),
        actions: <Widget>[
          IconButton(onPressed: () {
            if (Platform.isAndroid || Platform.isIOS){
              Navigator.pop(context);
            }
            if (Platform.isWindows || Platform.isLinux) {
              exit(0);
            }
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: const Botonera(),

    );
  }
}
