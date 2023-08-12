import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/tarefa_model.dart';

class TarefaService {
  final String apiUrl = "http://develop.api.task.nologic.pt/api/tarefa";

  Future<List<Tarefa>> gets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Tarefa.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tarefas');
    }
  }

  Future<Tarefa> get(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Tarefa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tarefa');
    }
  }

  Future<Tarefa> post(Tarefa tarefa) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tarefa.toJson(includeId: false)),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return tarefa;
    } else {
      throw Exception('Failed to create tarefa');
    }
  }

  Future<Tarefa> put(Tarefa tarefa) async {
    final response = await http.put(
      Uri.parse(apiUrl), // Removing the ID from the URI
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tarefa.toJson()),
    );

    if (response.statusCode == 200) {
      // Parse the updated object from the response
      return Tarefa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit tarefa');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete tarefa');
    }
  }
}
