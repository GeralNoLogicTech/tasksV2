import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;

class TarefaetiquetaFicha extends StatefulWidget {
  @override
  _TarefaetiquetaFichaState createState() => _TarefaetiquetaFichaState();
}

class _TarefaetiquetaFichaState extends State<TarefaetiquetaFicha> {
  late final tarefaetiqueta.Manager manager;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    manager = Provider.of<tarefaetiqueta.Manager>(context, listen: false);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(manager.data.teste);
  }
}
