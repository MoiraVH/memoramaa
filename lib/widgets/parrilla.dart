import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class Parrilla extends StatefulWidget {
  final Level? level;
  const Parrilla(this.level, {Key? key}) : super(key: key);

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla> {
  int? clicked, prevClicked, countClicks;
  bool? flag, habilitado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controles = [];
    baraja = [];
    estados = [];
    barajar(widget.level!);
    prevClicked = -1;
    clicked = 0;
    countClicks = 0;
    flag = false;
    habilitado = true;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: baraja.length,
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4),
        itemBuilder: (context, index) {
          return FlipCard(
              onFlip: () {
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
                  if (baraja.elementAt(index) ==
                      baraja.elementAt(prevClicked!)) {
                    debugPrint("Clicked: son iguales");
                    setState(() {
                      habilitado = true;
                    });
                  } else {
                    Future.delayed(
                      Duration(seconds: 1), () {
                      controles.elementAt(prevClicked!).toggleCard();
                      estados[prevClicked!] = true;
                      prevClicked = index;
                      controles.elementAt(index).toggleCard();
                      estados[index] = true;
                      setState(() {
                        habilitado = true;
                      });
                    },
                    );
                  }
                } else {

                }
              },
              fill: Fill.fillBack,
              controller: controles[index],
              flipOnTouch: habilitado! ? estados.elementAt(index) : false,
              //side: CardSide.FRONT,
              front: Image.asset("images/quest.png"),
              back: Image.asset(baraja[index]));
        });
  }
}
