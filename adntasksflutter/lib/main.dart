import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;
import 'package:adntasksflutter/features/tarefaetiqueta/data/service/tarefaetiqueta_service.dart';

void main() {
  runApp(
    FutureBuilder(
      future: _initializeManager(),
      builder: (context, AsyncSnapshot<tarefaetiqueta.Manager> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<tarefaetiqueta.Manager>.value(
            value: snapshot.data!,
            child: const MainApp(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}

Future<tarefaetiqueta.Manager> _initializeManager() async {
  var manager = tarefaetiqueta.Manager();
  manager.initialize(
    TarefaetiquetaService(),
    'http://develop.api.task.nologic.pt/api/tarefaetiqueta',
  );
  await manager.actions.updateList();
  return manager;
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Scaffold(
          body: Center(child: tarefaetiqueta.TarefaetiquetaLista()),
        ),
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: ColorSwatch(Colors.black, _swatch)));
  }
}
