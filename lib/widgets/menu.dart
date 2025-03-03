import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memorama/app/home.dart';
import 'package:memorama/db/sqlite.dart'; // Importa la base de datos
import 'package:memorama/db/victorias.dart';
import 'package:memorama/widgets/parrilla.dart';
import 'package:memorama/widgets/historial.dart';

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

          // Reiniciar juego
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reiniciar Juego'),
            onTap: () {
              Navigator.pop(context);
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

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Opciones'),
                    content: Container(
                      width: 300, // Ajusta el ancho del diálogo
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Información del juego
                          Text(
                            'Memorama',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Versión 1.0.0',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Información de los desarrolladores
                          Text(
                            'Desarrollado por:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Equipo Memorama',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Botón para ver el historial completo
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Historial(), // Navega a la pantalla de historial
                                ),
                              );
                            },
                            child: Text('Ver Historial Completo'),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
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
