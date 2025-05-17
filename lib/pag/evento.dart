import 'package:flutter/material.dart';
import '../model/evento.dart';
import '../service/event_supplies.dart'; // caminho corrigido
import 'evento_novo.dart';
import 'items_evento.dart';

class EventoPage extends StatefulWidget {
  const EventoPage({Key? key}) : super(key: key);

  @override
  _EventoPageState createState() => _EventoPageState();
}

class _EventoPageState extends State<EventoPage> {
  List<Evento> _eventos = [];

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final data = await EventSuppliesService.selectEvento();
    setState(() {
      _eventos = data.map((e) => Evento.fromMap(e)).toList();
    });
  }

  Future<void> _abrirFormularioEvento({Evento? evento}) async {
    final result = await Navigator.push<Evento>(
      context,
      MaterialPageRoute(
        builder: (_) => EventoNovo(evento: evento),
      ),
    );

    if (result != null) {
      if (evento == null) {
        await EventSuppliesService.insertEvento(result.toMap());
      } else {
        await EventSuppliesService.updateEvento(result.id!, result.toMap());
      }
      await _carregarEventos();
    }
  }

  Future<void> _excluirEvento(int id) async {
    await EventSuppliesService.deleteEvento(id);
    await _carregarEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: ListView.builder(
        itemCount: _eventos.length,
        itemBuilder: (context, index) {
          final evento = _eventos[index];
          return ListTile(
            title: Text(evento.nome),
            subtitle: Text('${evento.data} às ${evento.hora}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.checklist),
                  tooltip: 'Checklist',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemsEventoPage(eventoId: evento.id!),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _abrirFormularioEvento(evento: evento),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _excluirEvento(evento.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioEvento(),
        child: const Icon(Icons.add),
      ),
    );
  }
}