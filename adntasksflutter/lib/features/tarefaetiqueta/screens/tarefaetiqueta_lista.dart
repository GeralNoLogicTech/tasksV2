import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;

class TarefaetiquetaLista extends StatefulWidget {
  TarefaetiquetaLista({Key? key}) : super(key: key);

  @override
  TarefaetiquetaListaState createState() => TarefaetiquetaListaState();
}

class TarefaetiquetaListaState extends State<TarefaetiquetaLista> {
  late final tarefaetiqueta.Manager manager;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    manager = Provider.of<tarefaetiqueta.Manager>(context, listen: false);
    myController.text = manager.data.teste;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(manager.data.teste),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: myController,
                  onChanged: (value) {
                    setState(() {
                      manager.data.teste = value;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(manager.data.teste),
            ),
          ],
        ),
        floatingActionButton: Flla(
          onPressed: () {},
          child: const Text("Teste"),
        ));
  }
}
