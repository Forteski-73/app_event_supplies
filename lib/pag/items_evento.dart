import 'package:flutter/material.dart';
import '../model/items_evento.dart';
import '../service/event_supplies.dart';

class ItemsEventoPage extends StatefulWidget {
  final int eventoId;

  const ItemsEventoPage({Key? key, required this.eventoId}) : super(key: key);

  @override
  State<ItemsEventoPage> createState() => _ItemsEventoPageState();
}

class _ItemsEventoPageState extends State<ItemsEventoPage> {
  List<ItemsEvento> _itemsEvento = [];
  List<Map<String, dynamic>> _itensDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _loadItemsEvento();
    _loadItensDisponiveis();
  }

  Future<void> _loadItemsEvento() async {
    final data = await EventSuppliesService.getItemsPorEvento(widget.eventoId);
    setState(() {
      _itemsEvento = data.map((e) => ItemsEvento.fromMap(e)).toList();
    });
  }

  Future<void> _loadItensDisponiveis() async {
    final data = await EventSuppliesService.getItens();
    setState(() {
      _itensDisponiveis = data;
    });
  }

  Future<void> _addItemEvento() async {
    // Abre diálogo para escolher um item disponível que ainda não esteja no evento
    final List<int> itensIdsNoEvento = _itemsEvento.map((e) => e.itemId).toList();

    final Map<String, dynamic>? itemSelecionado = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Escolha um Item'),
          children: _itensDisponiveis
              .where((item) => !itensIdsNoEvento.contains(item['_id']))
              .map((item) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, item),
                    child: Text(item['nome']?.toString() ?? ''),
                  ))
              .toList(),
        );
      },
    );

    if (itemSelecionado != null) {
      // Cria novo ItemsEvento com valores padrão
      final novoItemEvento = ItemsEvento(
        eventoId: widget.eventoId,
        itemId: itemSelecionado['_id'],
        embalado: false,
        quantidadeEnviado: 0,
        quantidadeRetornado: 0,
        observacao: null,
      );

      await EventSuppliesService.insertItemEvento(novoItemEvento.toMap());
      await _loadItemsEvento();
    }
  }

  Future<void> _deleteItemEvento(ItemsEvento itemEvento) async {
    await EventSuppliesService.deleteItemEvento(itemEvento.eventoId, itemEvento.itemId);
    await _loadItemsEvento();
  }

  Future<void> _editObservacao(ItemsEvento itemEvento) async {
    final TextEditingController controller = TextEditingController(text: itemEvento.observacao ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Observação'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(hintText: 'Digite a observação'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text('Salvar')),
          ],
        );
      },
    );

    if (result != null) {
      final updated = ItemsEvento(
        eventoId: itemEvento.eventoId,
        itemId: itemEvento.itemId,
        embalado: itemEvento.embalado,
        quantidadeEnviado: itemEvento.quantidadeEnviado,
        quantidadeRetornado: itemEvento.quantidadeRetornado,
        observacao: result.isEmpty ? null : result,
      );

      await EventSuppliesService.updateItemEvento(itemEvento.eventoId, itemEvento.itemId, updated.toMap());
      await _loadItemsEvento();
    }
  }

  Future<void> _updateItemEvento(ItemsEvento itemEvento) async {
    await EventSuppliesService.updateItemEvento(itemEvento.eventoId, itemEvento.itemId, itemEvento.toMap());
    await _loadItemsEvento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens do Evento ${widget.eventoId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Adicionar Item',
            onPressed: _addItemEvento,
          ),
        ],
      ),
      body: _itemsEvento.isEmpty
          ? Center(child: Text('Nenhum item adicionado'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Embalado')),
                  DataColumn(label: Text('Qtd Enviada')),
                  DataColumn(label: Text('Qtd Retornada')),
                  DataColumn(label: Text('Observação')),
                  DataColumn(label: Text('Excluir')),
                ],
                rows: _itemsEvento.map((itemEvento) {
                  // Pegando nome do item na lista de itens disponíveis para mostrar na tabela
                  final itemNome = _itensDisponiveis.firstWhere(
                    (element) => element['_id'] == itemEvento.itemId,
                    orElse: () => {'nome': 'Item Desconhecido'},
                  )['nome'];

                  return DataRow(
                    cells: [
                      DataCell(Text(itemNome?.toString() ?? '')),
                      DataCell(
                        Checkbox(
                          value: itemEvento.embalado,
                          onChanged: (val) async {
                            final updated = ItemsEvento(
                              eventoId: itemEvento.eventoId,
                              itemId: itemEvento.itemId,
                              embalado: val ?? false,
                              quantidadeEnviado: itemEvento.quantidadeEnviado,
                              quantidadeRetornado: itemEvento.quantidadeRetornado,
                              observacao: itemEvento.observacao,
                            );
                            await _updateItemEvento(updated);
                          },
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: itemEvento.quantidadeEnviado.toString(),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (value) async {
                            double novaQtd = double.tryParse(value) ?? 0;
                            final updated = ItemsEvento(
                              eventoId: itemEvento.eventoId,
                              itemId: itemEvento.itemId,
                              embalado: itemEvento.embalado,
                              quantidadeEnviado: novaQtd,
                              quantidadeRetornado: itemEvento.quantidadeRetornado,
                              observacao: itemEvento.observacao,
                            );
                            await _updateItemEvento(updated);
                          },
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          initialValue: itemEvento.quantidadeRetornado.toString(),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (value) async {
                            double novaQtd = double.tryParse(value) ?? 0;
                            final updated = ItemsEvento(
                              eventoId: itemEvento.eventoId,
                              itemId: itemEvento.itemId,
                              embalado: itemEvento.embalado,
                              quantidadeEnviado: itemEvento.quantidadeEnviado,
                              quantidadeRetornado: novaQtd,
                              observacao: itemEvento.observacao,
                            );
                            await _updateItemEvento(updated);
                          },
                        ),
                      ),
                      DataCell(
                        InkWell(
                          child: Text(
                            itemEvento.observacao == null || itemEvento.observacao!.isEmpty
                                ? 'Adicionar'
                                : itemEvento.observacao!,
                            style: TextStyle(
                              fontStyle: itemEvento.observacao == null || itemEvento.observacao!.isEmpty
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () => _editObservacao(itemEvento),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItemEvento(itemEvento),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
