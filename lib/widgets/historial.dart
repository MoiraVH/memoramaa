import 'package:flutter/material.dart';
import 'package:memorama/db/sqlite.dart';
import 'package:memorama/db/victorias.dart';
import '../config/config.dart';

class Historial extends StatefulWidget {
  const Historial({Key? key}) : super(key: key);

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  List<Victorias> _victorias = [];
  List<Victorias> _derrotas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    final database = await Sqlite.db();

    // Cargar victorias
    final victoriasRaw = await database.query('Victorias', orderBy: 'fechaHora DESC');
    final derrotasRaw = await database.query('Derrotas', orderBy: 'fechaHora DESC');

    setState(() {
      _victorias = victoriasRaw.map((v) => Victorias.deMap(v)).toList();
      _derrotas = derrotasRaw.map((d) => Victorias.deMap(d)).toList();
      _isLoading = false;
    });
  }

  Widget _buildHistorialCard(Victorias registro, bool esVictoria) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  esVictoria ? 'Victoria' : 'Derrota',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: esVictoria ? Colors.green : Colors.red
                  ),
                ),
                Text(
                  _formatearFecha(registro.fechaHora),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Nivel: ${registro.nivel.name}'),
            Text('Movimientos: ${registro.movimientos}'),
            Text('Tiempo: ${registro.tiempo}'),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Juegos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              await _mostrarDialogoLimpiar();
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_victorias.isEmpty && _derrotas.isEmpty)
          ? const Center(child: Text('No hay registros de juegos'))
          : ListView(
        children: [
          if (_victorias.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Victorias',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            ..._victorias.map((v) => _buildHistorialCard(v, true)),
          ],
          if (_derrotas.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Derrotas',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            ..._derrotas.map((d) => _buildHistorialCard(d, false)),
          ],
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoLimpiar() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar Historial'),
          content: const Text('¿Estás seguro de que quieres borrar todo el historial de juegos?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Limpiar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await Sqlite.limpiarVictorias();
                await Sqlite.limpiarDerrotas();
                _cargarHistorial();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}