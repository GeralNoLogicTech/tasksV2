import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adntasksflutter/features/tarefa/tarefa.dart' as tarefa;
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class TarefaLista extends StatefulWidget {
  const TarefaLista({Key? key}) : super(key: key);

  @override
  TarefaListaState createState() => TarefaListaState();
}

class TarefaListaState extends State<TarefaLista> {
  late final tarefa.Manager tarefaManager;
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
    tarefaManager = Provider.of<tarefa.Manager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatActionButton(),
      drawer: const Drawer(),
      bottomNavigationBar: _buildNavigationbar(),
    );
  }

// ----> TOPAPPBAR
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Tarefas"),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
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
    );
  }
// ----X TOPAPPBAR

// ----> BODY
  Material _buildBody() {
    return Material(
      borderOnForeground: false,
      child: Container(
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            if (_isSearchboxVisible) _buildSearchBox(),
            Container(
              color: Theme.of(context).primaryColor,
              alignment: AlignmentDirectional.bottomEnd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, right: 2),
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(
                        Icons.expand_more,
                        color: Colors.white,
                      ),
                      label: const Text("Filtrar",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Colors.white, //elevated btton background color
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                      label: const Text("Ordenar",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Colors.white, //elevated btton background color
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Material(
                borderOnForeground: false,
                color: Theme.of(context).colorScheme.background,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  borderOnForeground: false,
                  color: Theme.of(context).colorScheme.background,
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
                      final groupedTasks =
                          manager.actions.groupTasksByDate(_filteredList);
                      final dates = groupedTasks.keys.toList();
                      dates.sort((a, b) {
                        if (a == 'Ultrapassada') return -1;
                        if (b == 'Ultrapassada') return 1;
                        if (a == 'Hoje') return -1;
                        if (b == 'Hoje') return 1;
                        if (a == 'Amanhã') return -1;
                        if (b == 'Amanhã') return 1;
                        return a.compareTo(b);
                      });
                      return CustomScrollView(
                        slivers: dates.map<Widget>((dateLabel) {
                          final tasksForDate = groupedTasks[dateLabel]!;
                          return SliverStickyHeader(
                            header: Container(
                              height: 40.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background, // Adjust this color to your theme if needed
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dateLabel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, taskIndex) {
                                  final task = tasksForDate[taskIndex];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              tarefa.TarefaFicha(
                                            tarefaItem: task,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 2, right: 2),
                                            title: Text(
                                                task.tarefaTitulo.toString()),
                                            subtitle: const Text(
                                                "Salvador Soares | Inovação"),
                                            leading: Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                value: task.tarefaEncerrada,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    task.tarefaEncerrada =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            trailing: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: CircleAvatar(
                                                child: Text(task.tarefaTitulo[0]
                                                    .toUpperCase()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            height: 1,
                                            thickness: 3),
                                      ],
                                    ),
                                  );
                                },
                                childCount: tasksForDate.length,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----> SEARCHBOX
  Card _buildSearchBox() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
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
    );
  }

// ----X BODY

// ----> NAVIGATIONBAR
  NavigationBar _buildNavigationbar() {
    return NavigationBar(
      indicatorColor: null,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: "Página inicial"),
        NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message_rounded),
            label: "Notificações"),
        NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group_add_rounded),
            label: "Clientes"),
        NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_off_outlined),
            label: "Projetos"),
      ],
    );
  }
// ----X NAVIGATIONBAR

// ----> FLOATINGACTIONBUTTON
  FloatingActionButton _buildFloatActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showBottomsheetAddTarefa(context),
      label: const Text("Adicionar tarefa", style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).primaryColorLight,
      isExtended: true,
    );
  }
// ----X FLOATINGACTIONBUTTON

// ----> BOTTOMSHEETS
  void _showBottomsheetAddTarefa(BuildContext context) {
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
                            tarefaDatalimite: DateTime.now(),
                          );
                          tarefaManager.actions.create(newTarefa);
                          setState(() {
                            _filteredList = tarefaManager.data.list;
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
// ----X BOTTOMSHEET