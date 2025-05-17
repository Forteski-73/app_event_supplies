import 'package:flutter/material.dart';
import '../model/item.dart';
import '../service/event_supplies.dart';
import 'item_novo.dart'; // importa a nova página

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final maps = await EventSuppliesService.getItens();
    setState(() {
      _items = maps.map((m) => Item.fromMap(m)).toList();
      _filteredItems = List.from(_items);
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        return item.nomeItem.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _openItemForm({Item? item}) async {
    final result = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (_) => ItemNew(item: item),
      ),
    );

    if (result != null) {
      if (item == null) {
        await EventSuppliesService.insertItem(result.toMap());
      } else {
        await EventSuppliesService.updateItem(result.id!, result.toMap());
      }
      await _loadItems();
    }
  }

  Future<void> _deleteItem(Item item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir Item'),
        content: Text('Deseja realmente excluir o item "${item.nomeItem}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Excluir')),
        ],
      ),
    );

    if (confirm == true && item.id != null) {
      await EventSuppliesService.deleteItem(item.id!);
      await _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Itens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar item',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(child: Text('Nenhum item encontrado.'))
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (_, index) {
                        final item = _filteredItems[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.nomeItem),
                            subtitle: Text('Quantidade: ${item.quantidade} ${item.unidadeMedida}\nCategoria ID: ${item.categoriaId}'),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _openItemForm(item: item),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteItem(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openItemForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar novo item',
      ),
    );
  }
}