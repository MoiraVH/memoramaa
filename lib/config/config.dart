library config.globals;

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../utilis/detalles.dart';
import '../widgets/tablero.dart';

enum Level {easy, medium, hard, impossible}

List<String> cards() {
  return[
    "images/cloud.png",
    "images/cloud.png",
    "images/day.png",
    "images/day.png",
    "images/dino.png",
    "images/dino.png",
    "images/fish.png",
    "images/fish.png",
    "images/frog.png",
    "images/frog.png",
    "images/moon.png",
    "images/moon.png",
    "images/night.png",
    "images/night.png",
    "images/octo.png",
    "images/octo.png",
    "images/peacock.png",
    "images/peacock.png",
    "images/rabbit.png",
    "images/rabbit.png",
    "images/rain.png",
    "images/rain.png",
    "images/rainbow.png",
    "images/rainbow.png",
    "images/seahorse.png",
    "images/seahorse.png",
    "images/shark.png",
    "images/shark.png",
    "images/star.png",
    "images/star.png",
    "images/sun.png",
    "images/sun.png",
    "images/whale.png",
    "images/whale.png",
    "images/wolf.png",
    "images/wolf.png",
    "images/zoo.png",
    "images/zoo.png",
  ];
}

List<Detalles> botones =[
  Detalles("Easy",
  Colors.green,
  Colors.green[200],
  const Tablero(Level.easy)),
  Detalles("Medium",
      Colors.yellow,
      Colors.yellow[200],
      const Tablero(Level.medium)),
  Detalles("Hard",
      Colors.deepOrangeAccent,
      Colors.deepOrange[200],
      const Tablero(Level.hard)),
  Detalles("Demon",
      Colors.red,
      Colors.red[200],
      const Tablero(Level.impossible)),
];

List<String> baraja=[];
List<FlipCardController> controles=[];
List<bool> estados=[];

void barajar(Level level) {
  int size=0;

  switch(level){
    case Level.easy:
      size=16;
      break;
    case Level.medium:
      size=24;
      break;
    case Level.hard:
      size=32;
      break;
    case Level.impossible:
      size=36;
      break; 
  }

  for (int i=0; i<size; i++){
    controles.add(FlipCardController());
    estados.add(true);

  }

  baraja = cards().sublist(0, size);
  baraja.shuffle();
}