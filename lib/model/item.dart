class Item {
  int? id;
  String nomeItem;
  String descricao;
  int categoriaId;
  double quantidade;
  String unidadeMedida;

  Item({
    this.id,
    required this.nomeItem,
    required this.descricao,
    required this.categoriaId,
    required this.quantidade,
    required this.unidadeMedida,
  });

  // Converter de Map (SQLite) para objeto Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['_id'],
      nomeItem: map['nome_item'],
      descricao: map['descricao'],
      categoriaId: map['categoria_id'],
      quantidade: map['quantidade'] is int
          ? (map['quantidade'] as int).toDouble()
          : map['quantidade'],
      unidadeMedida: map['unidade_medida'],
    );
  }

  // Converter de objeto Item para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    final map = {
      'nome_item': nomeItem,
      'descricao': descricao,
      'categoria_id': categoriaId,
      'quantidade': quantidade,
      'unidade_medida': unidadeMedida,
    };

    if (id != null) {
      map['_id'] = id!;
    }

    return map;
  }
}