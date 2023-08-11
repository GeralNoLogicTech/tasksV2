class Tarefa {
  int tarefaId;
  String tarefaTitulo;
  bool tarefaEncerrada;

  Tarefa(
      {required this.tarefaId,
      required this.tarefaTitulo,
      required this.tarefaEncerrada});

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      tarefaId: json['tarefaId'],
      tarefaTitulo: json['tarefaTitulo'],
      tarefaEncerrada: json['tarefaEncerrada'],
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final Map<String, dynamic> data = {};

    if (includeId) {
      data['tarefaId'] = tarefaId;
    }

    data['tarefaTitulo'] = tarefaTitulo;
    data['tarefaEncerrada'] = tarefaEncerrada;

    return data;
  }
}
