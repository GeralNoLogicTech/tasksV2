class Tarefaetiqueta {
  int tarefaetiquetaId;
  String tarefaetiquetaTitulo;

  Tarefaetiqueta(
      {required this.tarefaetiquetaId, required this.tarefaetiquetaTitulo});

  factory Tarefaetiqueta.fromJson(Map<String, dynamic> json) {
    return Tarefaetiqueta(
      tarefaetiquetaId: json['tarefaetiquetaId'],
      tarefaetiquetaTitulo: json['tarefaetiquetaTitulo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tarefaetiquetaId': tarefaetiquetaId,
      'tarefaetiquetaTitulo': tarefaetiquetaTitulo,
    };
  }
}
