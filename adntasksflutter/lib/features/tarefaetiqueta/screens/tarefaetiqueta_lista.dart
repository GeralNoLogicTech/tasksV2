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
          elevation: 5,
          centerTitle: false,
        ),
        body: ListView.builder(
          itemCount: manager.data.list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  manager.data.list[index].tarefaetiquetaTitulo.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tarefaetiqueta.TarefaetiquetaFicha(
                        tarefaItem: manager.data.list[index]),
                  ),
                );
              }, // change .toString() to access your specific model properties
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text("Adicionar etiqueta"),
          icon: const Icon(Icons.add),
        ),
        drawer: const Drawer(),
        bottomNavigationBar: NavigationBar(destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.search),
              label: "Search"),
        ],
        elevation: 5),
      );
  }
}
