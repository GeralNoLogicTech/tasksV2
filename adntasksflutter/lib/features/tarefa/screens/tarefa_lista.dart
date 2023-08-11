import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefa/tarefa.dart' as tarefa;

class TarefaLista extends StatefulWidget {
  const TarefaLista({Key? key}) : super(key: key);

  @override
  TarefaListaState createState() => TarefaListaState();
}

class TarefaListaState extends State<TarefaLista> {
  late final tarefa.Manager manager;
  String searchText = '';
  final TextEditingController _searchboxTextController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchboxVisible = false;
  late List<tarefa.Tarefa> _filteredList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<tarefa.Manager>().actions.updateList());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    manager = Provider.of<tarefa.Manager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas"),
        centerTitle: false,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchboxVisible = !_isSearchboxVisible;
              });
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Material(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 3,
        borderOnForeground: false,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              if (_isSearchboxVisible)
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(5),
                  shadowColor: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  borderOnForeground: false,
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      controller: _searchboxTextController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_searchboxTextController.text.isNotEmpty) {
                              _searchboxTextController.clear();
                              setState(() {
                                searchText = '';
                              });
                            } else {
                              setState(() {
                                _isSearchboxVisible = false;
                              });
                            }
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  borderOnForeground: false,
                  child: Consumer<tarefa.Manager>(
                    builder: (context, manager, child) {
                      _filteredList = searchText.isNotEmpty
                          ? manager.data.list
                              .where((item) =>
                                  item.tarefaTitulo
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) &&
                                  !item.tarefaEncerrada)
                              .toList()
                          : manager.data.list
                              .where((item) => !item.tarefaEncerrada)
                              .toList();
                      return ListView.builder(
                        itemCount: _filteredList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to tarefaedit screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => tarefa.TarefaFicha(
                                    tarefaItem: _filteredList[index],
                                  ),
                                ),
                              );
                            },
                            child: Material(
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.surfaceTint,
                              elevation: 3,
                              borderOnForeground: false,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5),
                                  dense: true,
                                  title: Text(_filteredList[index]
                                      .tarefaTitulo
                                      .toString()),
                                  leading: Checkbox(
                                    value: _filteredList[index].tarefaEncerrada,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _filteredList[index].tarefaEncerrada =
                                            value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
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
        onPressed: () => _showAddTarefaBottomSheet(context),
        label: const Text("Adicionar tarefa"),
        icon: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_sharp), label: "Página inicial"),
          NavigationDestination(
              icon: Icon(Icons.message_sharp), label: "Notificações"),
          NavigationDestination(icon: Icon(Icons.group), label: "Clientes"),
          NavigationDestination(icon: Icon(Icons.folder), label: "Projetos"),
        ],
      ),
    );
  }

  void _showAddTarefaBottomSheet(BuildContext context) {
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
                          var newTarefa = tarefa.Tarefa(
                            tarefaId: 0,
                            tarefaTitulo: titleController.text,
                            tarefaEncerrada: false,
                          );
                          manager.actions.create(newTarefa);
                          setState(() {
                            _filteredList = manager.data.list;
                          });
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
