import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefa/tarefa.dart' as tarefa;
import 'package:adntasksflutter/features/tarefa/data/service/tarefa_service.dart';

void main() {
  runApp(
    FutureBuilder(
      future: _initializeManager(),
      builder: (context, AsyncSnapshot<tarefa.Manager> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<tarefa.Manager>.value(
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

Future<tarefa.Manager> _initializeManager() async {
  var manager = tarefa.Manager();
  manager.initialize(
    TarefaService(),
    'http://develop.api.task.nologic.pt/api/tarefa',
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
          body: Center(child: tarefa.TarefaLista()),
        ),
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.grey));
  }
}
