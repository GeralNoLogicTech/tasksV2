import 'package:flutter/material.dart';
import 'package:adntasksflutter/features/tarefaetiqueta/tarefaetiqueta.dart'
    as tarefaetiqueta;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
