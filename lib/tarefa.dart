class Tarefa {
  final String id;
  final String nome;
  bool concluido;
  DateTime? data;

  // Construtor Padrão (para novas tarefas)
  Tarefa(this.nome, {this.concluido = false, required this.data})
    // Lista de Inicialização: Gera um ID único baseado no tempo
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  // Construtor fromJson (para carregar tarefas do JSON)
  Tarefa.fromJson(Map<String, dynamic> json)
    // Lista de Inicialização: Lê os valores do Map JSON
    : id = json['id'] as String,
      nome = json['nome'] as String,
      concluido = json['concluido'] as bool,
      // Converte a string salva de volta para DateTime, ou null
      data = json['data'] != null ? DateTime.parse(json['data']) : null;

  // Método toJson (para salvar a tarefa no JSON)
  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'concluido': concluido,
    // Converte DateTime para String (formato ISO 8601)
    'data': data?.toIso8601String(),
  };
}
