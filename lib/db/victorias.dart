import '../config/config.dart';

class Victorias{
  int? id;
  String? resultado;
  Level? nivel;
  int? movimientos;
  String tiempo;
  DateTime fechaHora;

  Victorias({
    this.id,
    required this.resultado,
    required this.nivel,
    required this.movimientos,
    required this.tiempo,
    DateTime? fechaHora,
  }) : fechaHora = fechaHora ?? DateTime.now();

  Victorias.deMap(Map<String, dynamic>map){
    id =            map["id"];
    resultado =     map["resultado"];
    nivel =         Level.values.firstWhere((e) => e.toString() == map["nivel"]);
    movimientos =   map["movimientos"];
    tiempo =        map["tiempo"];
    fechaHora =     DateTime.parse(map["fechaHora"]);
    }

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "resultado": resultado,
      "nivel": nivel?.toString(),
      "movimientos": movimientos,
      "tiempo": tiempo,
      "fechaHora": fechaHora?.toIso8601String(),
    };
  }
}