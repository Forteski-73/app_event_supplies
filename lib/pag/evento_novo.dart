import 'package:flutter/material.dart';
import '../model/evento.dart';

class EventoNovo extends StatefulWidget {
  final Evento? evento;

  const EventoNovo({Key? key, this.evento}) : super(key: key);

  @override
  _EventoNovoState createState() => _EventoNovoState();
}

class _EventoNovoState extends State<EventoNovo> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController situacaoController;
  late TextEditingController dataController;
  late TextEditingController horaController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.evento?.nome ?? '');
    descricaoController = TextEditingController(text: widget.evento?.descricao ?? '');
    situacaoController = TextEditingController(text: widget.evento?.situacao ?? '');
    dataController = TextEditingController(text: widget.evento?.data ?? '');
    horaController = TextEditingController(text: widget.evento?.hora ?? '');
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final novoEvento = Evento(
        id: widget.evento?.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        situacao: situacaoController.text,
        data: dataController.text,
        hora: horaController.text,
      );
      Navigator.of(context).pop(novoEvento);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.evento == null ? 'Novo Evento' : 'Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              TextFormField(
                controller: situacaoController,
                decoration: const InputDecoration(labelText: 'Situação'),
              ),
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(labelText: 'Data (AAAA-MM-DD)'),
              ),
              TextFormField(
                controller: horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}