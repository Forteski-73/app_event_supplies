class ItemsEvento {
  int eventoId;
  int itemId;
  bool embalado; // booleano representado como inteiro no banco (0 ou 1)
  double quantidadeEnviado;
  double quantidadeRetornado;
  String? observacao; // pode ser null

  ItemsEvento({
    required this.eventoId,
    required this.itemId,
    required this.embalado,
    required this.quantidadeEnviado,
    required this.quantidadeRetornado,
    this.observacao,
  });

  // Converter Map do banco para objeto
  factory ItemsEvento.fromMap(Map<String, dynamic> map) {
    return ItemsEvento(
      eventoId: map['evento_id'] as int,
      itemId: map['item_id'] as int,
      embalado: (map['embalado'] as int) == 1,
      quantidadeEnviado: (map['quantidade_enviado'] as num).toDouble(),
      quantidadeRetornado: (map['quantidade_retornado'] as num).toDouble(),
      observacao: map['observacao'] as String?,
    );
  }

  // Converter objeto para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'evento_id': eventoId,
      'item_id': itemId,
      'embalado': embalado ? 1 : 0,
      'quantidade_enviado': quantidadeEnviado,
      'quantidade_retornado': quantidadeRetornado,
      'observacao': observacao,
    };
  }
}