import 'dart:async';
import 'package:event/event.dart';
import 'package:flutter/foundation.dart';

import '../service/tarefa_service.dart';
import '../../models/tarefa_model.dart';

class Manager extends ChangeNotifier {
  late Actions actions;
  late State state;
  late Data data;
  late String baseUrl;

  TarefaService? tarefaService;

  Manager._internal() {
    var localData = Data();
    data = localData;
  }

  static final Manager _singleton = Manager._internal();

  factory Manager() {
    return _singleton;
  }

  void initialize(TarefaService tarefaService, String baseUrl) {
    this.tarefaService = tarefaService;
    this.baseUrl = baseUrl;

    var localData = Data();
    data = localData;
    actions = Actions(this, tarefaService, localData);
    state = State();
  }

  // Expose a public method to notify listeners
  void updateListeners() {
    notifyListeners();
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
  final Manager manager;
  TarefaService tarefaService;
  Data data;

  Actions(this.manager, this.tarefaService, this.data);

  Future updateList() async {
    var newList = await tarefaService.gets();
    data.setList(newList);
    manager.updateListeners();
  }

  Future create(Tarefa tarefa) async {
    await tarefaService.post(tarefa);
    updateList();
  }

  Future edit(Tarefa tarefa) async {
    await tarefaService.put(tarefa);
    updateList();
  }

  Future delete(int tarefaId) async {
    await tarefaService.delete(tarefaId);
    updateList();
  }
}

class Data {
  List<Tarefa> list = [];

  String teste = "teste";

  void setList(List<Tarefa> newList) {
    list = newList;
  }
}
