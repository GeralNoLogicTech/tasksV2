import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;
import 'package:adntasksflutter/features/tarefaetiqueta/data/service/tarefaetiqueta_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider<tarefaetiqueta.Manager>(
      create: (context) {
        var manager = tarefaetiqueta.Manager();
        manager.initialize(
          TarefaetiquetaService(),
          'yourBaseUrl',
        );
        return manager;
      },
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: tarefaetiqueta.TarefaetiquetaLista()),
      ),
    );
  }
}
