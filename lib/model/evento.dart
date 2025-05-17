class Evento {
  int? id;
  String nome;
  String descricao;
  String situacao;
  String data;
  String hora;

  Evento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.situacao,
    required this.data,
    required this.hora,
  });

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['_id'],
      nome: map['nome'],
      descricao: map['descricao'],
      situacao: map['situacao'],
      data: map['data'],
      hora: map['hora'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      '_id' : id,
      'nome': nome,
      'descricao': descricao,
      'situacao': situacao,
      'data': data,
      'hora': hora,
    };
    return map;
  }
}
