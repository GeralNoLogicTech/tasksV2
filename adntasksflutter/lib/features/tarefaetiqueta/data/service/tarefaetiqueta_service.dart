import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/tarefaetiqueta_model.dart';

class TarefaetiquetaService {
  final String apiUrl = "http://develop.api.task.nologic.pt/api/tarefaetiqueta";

  Future<List<Tarefaetiqueta>> gets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Tarefaetiqueta.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tarefaetiquetas');
    }
  }

  Future<Tarefaetiqueta> get(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Tarefaetiqueta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tarefaetiqueta');
    }
  }

  Future<Tarefaetiqueta> post(Tarefaetiqueta tarefaetiqueta) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tarefaetiqueta.toJson(includeId: false)),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
        return tarefaetiqueta; 
    } else {
        print(response.body);
        throw Exception('Failed to create tarefaetiqueta');
    }
}

  Future<Tarefaetiqueta> put(Tarefaetiqueta tarefaetiqueta) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${tarefaetiqueta.tarefaetiquetaId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tarefaetiqueta.toJson()),
    );

    if (response.statusCode == 200) {
      return Tarefaetiqueta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tarefaetiqueta');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete tarefaetiqueta');
    }
  }
}
