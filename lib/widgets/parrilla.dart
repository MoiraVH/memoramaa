import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import '../app/home.dart';
import '../config/config.dart';
import 'menu.dart';

class Parrilla extends StatefulWidget {
  final Level? level;
  final bool? newGame;
  const Parrilla(this.level, {Key? key, this.newGame = false}) : super(key: key);

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla> {
  int? prevClicked;
  bool? flag, habilitado;
  bool mostrandoInicial = true;
  bool juegoIniciado = false; // Solo empieza cuando todas las cartas están volteadas

  // Variables para estadísticas
  int movimientos = 0;
  int paresEncontrados = 0;
  int totalPares = 0;
  Stopwatch cronometro = Stopwatch();
  Timer? timer;
  String tiempoTranscurrido = "00:00";
  bool gameOver =false;

  @override
  void initState() {
    super.initState();
    baraja = [];
    controles = [];
    estados = [];
    barajar(widget.level!);

    // Inicializar variables de juego
    prevClicked = -1;
    flag = false;
    habilitado = false;

    // Inicializar estadísticas
    movimientos = 0;
    paresEncontrados = 0;
    totalPares = baraja.length ~/ 2; // Cada carta tiene su par

    // Iniciar el cronómetro
    cronometro.start();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && !gameOver) {
        setState(() {
          // Formato mm:ss
          int segundos = cronometro.elapsed.inSeconds;
          int minutos = segundos ~/ 60;
          segundos = segundos % 60;
          tiempoTranscurrido =
          "${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(
              2, '0')}";

          if (minutos >= 3) {
            _gameOverLose();
          }
        });
      }
    });

    // Mostrar cartas al inicio y luego voltearlas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Voltear todas las cartas para mostrarlas inicialmente
      for (var controller in controles) {
        controller.toggleCard();
      }

      // Esperar 3 segundos y voltearlas de nuevo
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            for (var controller in controles) {
              controller.toggleCard();
            }
            juegoIniciado = true;
            mostrandoInicial = false;
            habilitado = true;

            // Activar los estados de las cartas
            for (int i = 0; i < estados.length; i++) {
              estados[i] = true;
            }
          });
        }
      });
    });
  }


  void _gameOverLose() {
    if (gameOver) return;

    setState(() {
      gameOver = true;
    });

    cronometro.stop();
    timer?.cancel();


    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("¡Tiempo Agotado!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Se acabó el tiempo"),
              SizedBox(height: 16),
              Text("Tiempo: $tiempoTranscurrido"),
              Text("Movimientos: $movimientos"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                      (route) => false,
                );
              },
              child: Text("Volver al menú"),
            ),
          ],
        ),
      );
    });
  }

  void _gameOverWin() {
    if (gameOver) return;

    setState(() {
      gameOver = true;
    });

    cronometro.stop();
    timer?.cancel();


    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("¡Felicidades!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Has completado el juego"),
              SizedBox(height: 16),
              Text("Tiempo: $tiempoTranscurrido"),
              Text("Movimientos: $movimientos"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                      (route) => false,
                );
              },
              child: Text("Volver al menú"),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    cronometro.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memorama"),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: Menu(level: widget.level),

        body: Column(
          children: [
            // Barra de estadísticas
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Movimientos
                  Text(
                    "Movimientos: $movimientos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Pares encontrados/total
                  Text(
                    "Pares: $paresEncontrados/$totalPares",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Tiempo transcurrido
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 4),
                      Text(
                        tiempoTranscurrido,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rejilla de juego
            Expanded(
              child: GridView.builder(
                  itemCount: baraja.length,
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    return FlipCard(
                      onFlip: () {
                        if (mostrandoInicial||!juegoIniciado)
                          return;

                        if (!flag!) {
                          prevClicked = index;
                          estados[index] = false;
                        } else {
                          setState(() {
                            habilitado = false;
                          });
                        }
                        flag = !flag!;
                        estados[index] = false;

                        if (prevClicked != index && !flag!) {
                          if (baraja.elementAt(index) == baraja.elementAt(prevClicked!)) {
                            debugPrint("clicked: Son Iguales");
                            setState(() {
                              habilitado = true;
                              paresEncontrados++;


                              // Verificar si se encontraron todos los pares
                              if (paresEncontrados == totalPares) {
                                _gameOverWin();
                              }
                            });
                          } else {
                            // Incrementar movimientos solo si las cartas no son iguales
                            setState(() {
                              movimientos++;
                            });

                            Future.delayed(Duration(seconds: 1), () {
                              controles.elementAt(prevClicked!).toggleCard();
                              estados[prevClicked!] = true;
                              prevClicked = index;
                              controles.elementAt(index).toggleCard();
                              estados[index] = true;
                              setState(() {
                                habilitado = true;
                              });
                            });
                          }
                        }
                      },
                      fill: Fill.fillBack,
                      controller: controles[index],
                      flipOnTouch: mostrandoInicial ? false : (habilitado! ? estados.elementAt(index) : false),
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      front: Image.asset("images/quest.png"),
                      back: Image.asset(baraja[index]),
                    );
                  }
              ),
            ),
          ],
        ),
    );
  }
}