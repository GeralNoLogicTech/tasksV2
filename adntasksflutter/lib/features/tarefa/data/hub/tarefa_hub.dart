import 'dart:async';
import 'package:event/event.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime parseStringToDate(String dateString) {
    if (!isDateStringValid(dateString)) {
      return DateTime
          .now(); // return a default date or any other logic you prefer
    }
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  bool isDateStringValid(String dateString) {
    final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return datePattern.hasMatch(dateString);
  }

  Map<String, List<Tarefa>> groupTasksByDate(List<Tarefa> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    // Group the tasks by date
    return {
      ...tasks.fold<Map<String, List<Tarefa>>>(
        {},
        (map, task) {
          final taskDate = task.tarefaDatalimite;
          late String key;

          if (taskDate.isBefore(today)) {
            key = 'Ultrapassada';
          } else if (taskDate.isAtSameMomentAs(today)) {
            key = 'Hoje';
          } else if (taskDate.isAtSameMomentAs(tomorrow)) {
            key = 'Amanhã';
          } else {
            key = DateFormat('EEE. dd/MM').format(taskDate);
          }

          (map[key] ??= []).add(task);
          return map;
        },
      )
    };
  }

  String getDateLabel(DateTime inputDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime date = DateTime(inputDate.year, inputDate.month, inputDate.day);

    if (date.isBefore(today)) {
      return 'Data ultrapassada';
    } else if (date == today) {
      return 'Hoje';
    } else if (date == tomorrow) {
      return 'Amanhã';
    } else {
      return formatDate(date);
    }
  }
}

class Data {
  List<Tarefa> list = [];

  void setList(List<Tarefa> newList) {
    list = newList;
  }
}
