import 'package:flutter/material.dart';
import 'package:lista_tarefas_app/tarefa.dart'; 
// Verifique se o import da sua classe Tarefa está correto

class TarefaDetalheScreen extends StatelessWidget {
  final Tarefa tarefa;

  const TarefaDetalheScreen({
    super.key,
    required this.tarefa,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'), 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ID: ${tarefa.id}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                'Nome: ${tarefa.nome}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Data de Criação: ${tarefa.data?.toString() ?? 'N/A'}',
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              Text(
                'Status: ${tarefa.concluido ? 'CONCLUÍDA' : 'PENDENTE'}',
                style: TextStyle(
                  fontSize: 18, 
                  color: tarefa.concluido ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}