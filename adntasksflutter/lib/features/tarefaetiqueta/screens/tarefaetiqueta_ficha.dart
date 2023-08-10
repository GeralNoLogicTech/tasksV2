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
  bool isTextChanged = false;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<tarefaetiqueta.Manager>(context, listen: false);
    myController = TextEditingController(
        text: widget.tarefaItem.tarefaetiquetaTitulo
            .toString()); // moved into initState
  }

  void _saveEdits() {
    tarefaetiqueta.Tarefaetiqueta updatedTarefa = tarefaetiqueta.Tarefaetiqueta(
      tarefaetiquetaId: widget.tarefaItem.tarefaetiquetaId,
      tarefaetiquetaTitulo: myController.text,
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
        body: Material(
          elevation: 10,
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          surfaceTintColor: Colors.green,
          borderOnForeground: false,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            margin: const EdgeInsets.all(2),
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
                                text != widget.tarefaItem.tarefaetiquetaTitulo;
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
