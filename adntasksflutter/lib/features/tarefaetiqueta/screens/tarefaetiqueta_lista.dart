import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;

class TarefaetiquetaLista extends StatefulWidget {
  const TarefaetiquetaLista({Key? key}) : super(key: key);

  @override
  TarefaetiquetaListaState createState() => TarefaetiquetaListaState();
}

class TarefaetiquetaListaState extends State<TarefaetiquetaLista> {
  late final tarefaetiqueta.Manager manager;
  String searchText = '';
  final TextEditingController _searchboxTextController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<tarefaetiqueta.Manager>().actions.updateList());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    manager = Provider.of<tarefaetiqueta.Manager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiquetas"),
        centerTitle: false,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt),
          ),
          IconButton(
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Material(
        elevation: 4,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        surfaceTintColor: Colors.teal,
        borderOnForeground: false,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                elevation: 0,
                margin: const EdgeInsets.all(0),
                shadowColor: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                borderOnForeground: false,
                child: TextField(
                    controller: _searchboxTextController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchboxTextController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      hintText: "Pesquisar",
                      border: InputBorder.none,
                    )),
              ),
              Expanded(
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(top: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  borderOnForeground: false,
                  child: Consumer<tarefaetiqueta.Manager>(
                    builder: (context, manager, child) {
                      return ListView.builder(
                        itemCount: manager.data.list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(manager
                                .data.list[index].tarefaetiquetaTitulo
                                .toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      tarefaetiqueta.TarefaetiquetaFicha(
                                          tarefaItem: manager.data.list[index]),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTarefaetiquetaBottomSheet(context),
        label: const Text("Adicionar etiqueta"),
        icon: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_sharp), label: "Página inicial"),
        NavigationDestination(
            icon: Icon(Icons.message_sharp), label: "Notificações"),
        NavigationDestination(icon: Icon(Icons.group), label: "Clientes"),
        NavigationDestination(icon: Icon(Icons.folder), label: "Projetos"),
      ], elevation: 3),
    );
  }

  void _showAddTarefaetiquetaBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        elevation: 5,
        showDragHandle: true,
        builder: (BuildContext context) {
          TextEditingController titleController = TextEditingController();
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 10,
              left: 10,
              right: 10,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Guardar'),
                        onPressed: () {
                          var newTarefaetiqueta = tarefaetiqueta.Tarefaetiqueta(
                            tarefaetiquetaId: 0,
                            tarefaetiquetaTitulo: titleController.text,
                          );
                          manager.actions.create(newTarefaetiqueta);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
