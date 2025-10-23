import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_tarefas_app/tarefa.dart';
// Verifique se o import da sua classe Tarefa está correto

// Chave única para salvar a lista completa no SharedPreferences
const String _storageKey = 'listaDeTarefasJson';

class TarefaStorage {
  // FUNÇÃO SALVAR (Escreve a String JSON)
  Future<void> saveTarefas(List<Tarefa> tarefas) async {
    final listaDeMaps = tarefas.map((tarefa) => tarefa.toJson()).toList();
    final jsonString = jsonEncode(listaDeMaps);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonString);
  }

  // FUNÇÃO CARREGAR (Lê a String JSON)
  Future<List<Tarefa>> readTarefas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null) {
        return [];
      }

      final listaDinamica = jsonDecode(jsonString) as List<dynamic>;

      // Converte a lista dinâmica de Maps de volta para List<Tarefa>
      final listaDeTarefas = listaDinamica
          .map((jsonMap) => Tarefa.fromJson(jsonMap as Map<String, dynamic>))
          .toList();

      // O cast é necessário para tipagem
      return listaDeTarefas as List<Tarefa>;
    } catch (e) {
      print('Erro ao carregar as tarefas com Shared Preferences: $e');
      return [];
    }
  }
}
