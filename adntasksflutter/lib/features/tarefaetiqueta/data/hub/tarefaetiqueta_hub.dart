import 'dart:async';
import 'package:event/event.dart';
import 'package:flutter/foundation.dart';

import '../service/tarefaetiqueta_service.dart';
import '../../models/tarefaetiqueta_model.dart';

class Manager extends ChangeNotifier {
  late Actions actions;
  late State state;
  late Data data;
  late String baseUrl;

  TarefaetiquetaService? tarefaetiquetaService;

  Manager._internal() {
    var localData = Data();
    data = localData;
  }

  static final Manager _singleton = Manager._internal();

  factory Manager() {
    return _singleton;
  }

  void initialize(TarefaetiquetaService tarefaetiquetaService, String baseUrl) {
    this.tarefaetiquetaService = tarefaetiquetaService;
    this.baseUrl = baseUrl;

    var localData = Data();
    data = localData;
    actions = Actions(this, tarefaetiquetaService, localData);
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
  TarefaetiquetaService tarefaetiquetaService;
  Data data;

  Actions(this.manager, this.tarefaetiquetaService, this.data);

  Future updateList() async {
    var newList = await tarefaetiquetaService.gets();
    data.setList(newList);
    manager.updateListeners();
  }

  Future create(Tarefaetiqueta tarefaetiqueta) async {
    await tarefaetiquetaService.post(tarefaetiqueta);
    updateList();
  }

  Future edit(Tarefaetiqueta tarefaetiqueta) async {
    await tarefaetiquetaService.put(tarefaetiqueta);
    updateList();
  }

  Future delete(int tarefaetiquetaId) async {
    await tarefaetiquetaService.delete(tarefaetiquetaId);
    updateList();
  }
}

class Data {
  List<Tarefaetiqueta> list = [];

  String teste = "teste";

  void setList(List<Tarefaetiqueta> newList) {
    list = newList;
  }
}
