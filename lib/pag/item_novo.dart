import 'package:flutter/material.dart';
import '../model/item.dart';

class ItemNew extends StatefulWidget {
  final Item? item;

  const ItemNew({Key? key, this.item}) : super(key: key);

  @override
  State<ItemNew> createState() => _ItemNewState();
}

class _ItemNewState extends State<ItemNew> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController categoriaIdController;
  late TextEditingController quantidadeController;
  late TextEditingController unidadeMedidaController;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nomeController = TextEditingController(text: item?.nomeItem ?? '');
    descricaoController = TextEditingController(text: item?.descricao ?? '');
    categoriaIdController = TextEditingController(text: item?.categoriaId?.toString() ?? '');
    quantidadeController = TextEditingController(text: item?.quantidade?.toString() ?? '');
    unidadeMedidaController = TextEditingController(text: item?.unidadeMedida ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    categoriaIdController.dispose();
    quantidadeController.dispose();
    unidadeMedidaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newItem = Item(
        id: widget.item?.id,
        nomeItem: nomeController.text,
        descricao: descricaoController.text,
        categoriaId: int.parse(categoriaIdController.text),
        quantidade: double.parse(quantidadeController.text),
        unidadeMedida: unidadeMedidaController.text,
      );
      Navigator.of(context).pop(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Item'),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe a descrição' : null,
              ),
              TextFormField(
                controller: categoriaIdController,
                decoration: InputDecoration(labelText: 'ID da Categoria'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o ID da categoria';
                  if (int.tryParse(v) == null) return 'Deve ser um número inteiro';
                  return null;
                },
              ),
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a quantidade';
                  if (double.tryParse(v) == null) return 'Deve ser um número';
                  return null;
                },
              ),
              TextFormField(
                controller: unidadeMedidaController,
                decoration: InputDecoration(labelText: 'Unidade de Medida'),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe a unidade de medida' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.item == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}