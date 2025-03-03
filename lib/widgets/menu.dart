import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorama/app/home.dart';
import 'package:memorama/widgets/parrilla.dart';

import '../config/config.dart';

class Menu extends StatelessWidget {
  final Level? level;

  const Menu({Key? key, this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          // Checar el reiniciar juego
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reiniciar Juego'),
            onTap: () {
              Navigator.pop(context);
              // Reinicia con el mismo nivel y misma disposición de cartas
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Parrilla(level, newGame: true),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.games),
            title: Text('Juego nuevo'),
            onTap: () {
              Navigator.pop(context);
              // Crea juego con nuevo nivel o nueva disposición
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Parrilla(level, newGame: false),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Salir'),
            onTap: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Opciones'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer

              // Muestra un diálogo con información
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Opciones'),
                    content: Container(
                      width: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Información del juego:'),
                          SizedBox(height: 50),
                          Text('Versión: 1.0.0'),
                          Text('Desarrollador: Tu nombre'),

                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
