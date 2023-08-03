import 'dart:async';
import 'package:event/event.dart';

import '../service/tarefaetiqueta_service.dart';
import '../../models/tarefaetiqueta_model.dart';

class Manager {
  late Actions actions;
  late State state;
  late Data data;
  String baseUrl;
  String hubPath;

  Manager(
      TarefaetiquetaService tarefaetiquetaService, this.baseUrl, this.hubPath) {
    var localData = Data();
    data = localData;
    actions = Actions(tarefaetiquetaService, localData);
    state = State();
  }
}

class State {
  late Event stateEvent = Event();

  void update() {
    stateEvent.broadcast();
  }

  void clear() {
    stateEvent.broadcast();
  }
}

class Actions {
  TarefaetiquetaService tarefaetiquetaService;
  Data data;

  Actions(this.tarefaetiquetaService, this.data);

  Future updateList() async {
    var newList = await tarefaetiquetaService.gets();
    data.setList(newList);
  }

  Future create(Tarefaetiqueta tarefaetiqueta) async {
    await tarefaetiquetaService.post(tarefaetiqueta);
  }

  Future edit(Tarefaetiqueta tarefaetiqueta) async {
    await tarefaetiquetaService.put(tarefaetiqueta);
  }

  Future delete(int tarefaetiquetaId) async {
    await tarefaetiquetaService.delete(tarefaetiquetaId);
  }
}

class Data {
  List<Tarefaetiqueta> list = [];

  void setList(List<Tarefaetiqueta> newList) {
    list = newList;
  }
}
