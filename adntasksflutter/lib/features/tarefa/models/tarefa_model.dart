class Tarefa {
  int tarefaId;
  String tarefaTitulo;
  bool tarefaEncerrada;
  DateTime tarefaDatalimite;

  Tarefa(
      {required this.tarefaId,
      required this.tarefaTitulo,
      required this.tarefaEncerrada,
      required this.tarefaDatalimite});

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      tarefaId: json['tarefaId'],
      tarefaTitulo: json['tarefaTitulo'],
      tarefaEncerrada: json['tarefaEncerrada'],
      tarefaDatalimite: DateTime.parse(json['tarefaDatalimite']),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final Map<String, dynamic> data = {};

    if (includeId) {
      data['tarefaId'] = tarefaId;
    }

    data['tarefaTitulo'] = tarefaTitulo;
    data['tarefaEncerrada'] = tarefaEncerrada;
    data['tarefaDatalimite'] = tarefaDatalimite.toIso8601String();

    return data;
  }
}
