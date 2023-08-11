import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefa/tarefa.dart' as tarefa;

class TarefaFicha extends StatefulWidget {
  final tarefa.Tarefa tarefaItem;

  const TarefaFicha({Key? key, required this.tarefaItem}) : super(key: key);

  @override
  TarefaFichaState createState() => TarefaFichaState();
}

class TarefaFichaState extends State<TarefaFicha> {
  late final tarefa.Manager manager;
  late TextEditingController myController;
  bool isTextChanged = false;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<tarefa.Manager>(context, listen: false);
    myController = TextEditingController(
        text:
            widget.tarefaItem.tarefaTitulo.toString()); // moved into initState
  }

  void _saveEdits() {
    tarefa.Tarefa updatedTarefa = tarefa.Tarefa(
      tarefaId: widget.tarefaItem.tarefaId,
      tarefaTitulo: myController.text,
      tarefaEncerrada: true,
    );

    manager.actions.edit(updatedTarefa);
    Navigator.pop(context);
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
            elevation: 3,
            actions: [
              IconButton(
                onPressed: () {
                  manager.actions.delete(widget.tarefaItem.tarefaId);
                  Navigator.pop(
                      context); // This line will send you back to the previous screen
                },
                icon: const Icon(Icons.delete),
              ),
            ]),
        body: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          borderOnForeground: false,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            margin: const EdgeInsets.all(0),
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(4),
                    shadowColor: null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    borderOnForeground: false,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          setState(() {
                            isTextChanged =
                                text != widget.tarefaItem.tarefaTitulo;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
        floatingActionButton: isTextChanged
            ? FloatingActionButton.extended(
                label: const Text("Salvar"),
                onPressed: _saveEdits,
                icon: const Icon(Icons.save),
              )
            : null);
  }
}
