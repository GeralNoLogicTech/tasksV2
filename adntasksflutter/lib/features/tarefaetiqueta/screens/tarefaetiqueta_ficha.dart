import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;

class TarefaetiquetaFicha extends StatefulWidget {
  final tarefaetiqueta.Tarefaetiqueta tarefaItem;

  const TarefaetiquetaFicha({Key? key, required this.tarefaItem})
      : super(key: key);

  @override
  TarefaetiquetaFichaState createState() => TarefaetiquetaFichaState();
}

class TarefaetiquetaFichaState extends State<TarefaetiquetaFicha> {
  late final tarefaetiqueta.Manager manager;
  late TextEditingController myController;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<tarefaetiqueta.Manager>(context, listen: false);
    myController = TextEditingController(
        text: widget.tarefaItem.tarefaetiquetaTitulo
            .toString()); // moved into initState
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Editar'),
            centerTitle: false,
            elevation: 4,
            actions: [
              IconButton(
                onPressed: () {
                  manager.actions.delete(widget.tarefaItem.tarefaetiquetaId);
                  Navigator.pop(
                      context); // This line will send you back to the previous screen
                },
                icon: const Icon(Icons.delete),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: myController,
            decoration: const InputDecoration(
              labelText: 'Título',
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
        bottomNavigationBar: NavigationBar(destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_sharp), label: "Página inicial"),
          NavigationDestination(
              icon: Icon(Icons.message_sharp), label: "Notificações"),
          NavigationDestination(icon: Icon(Icons.group), label: "Clientes"),
          NavigationDestination(icon: Icon(Icons.folder), label: "Projetos"),
        ], elevation: 3),
        floatingActionButton: const FloatingActionButton.extended(
          label: Text("Salvar"),
          onPressed: null,
          icon: Icon(Icons.save),
        ));
  }
}
