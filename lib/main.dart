import 'package:flutter/material.dart';
import 'package:lista_tarefas_app/tarefa_detalhe_screen';
import 'package:lista_tarefas_app/tarefa_storage.dart';
import 'tarefa.dart';

void main() {
  runApp(ListaTarefasApp());
}

class ListaTarefasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // === TEMA CLEAN (Passo 1 da Tematização) ===
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[50], // Fundo sutilmente cinza

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0, // Sem sombra na AppBar
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),

        // Cor de Destaque (Accent Color) para interações
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
            .copyWith(
              secondary: Colors.teal, // Cor verde/azul para o checkmark
            ),

        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1.0, // Sombra sutil
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        ),
      ),

      // ===========================================
      home: ListaScreen(),
    );
  }
}

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  // Instância do Serviço de Persistência
  final TarefaStorage _storage = TarefaStorage();

  List<Tarefa> tarefas = <Tarefa>[];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregamento de Dados ao iniciar a tela
    _storage.readTarefas().then((listaCarregada) {
      setState(() {
        tarefas = listaCarregada;
      });
    });
  }

  // --- Lógica de CRUD (Todas chamam saveTarefas) ---

  void adicionarTarefa(String nome) {
    final texto = nome.trim();
    if (texto.isEmpty) return;
    setState(() {
      // Data de exemplo
      tarefas.add(Tarefa(texto, data: DateTime.now()));
      _controller.clear();
      _storage.saveTarefas(tarefas);
    });
  }

  void tarefaConcluida(int index) {
    setState(() {
      tarefas[index].concluido = !tarefas[index].concluido;
      _storage.saveTarefas(tarefas);
    });
  }

  void removerTarefa(int index) {
    tarefas.removeAt(index);
    _storage.saveTarefas(tarefas);
  }

  // --- Construção do Item da Lista ---

  Widget _buildItem(BuildContext context, int index) {
    final tarefa = tarefas[index];
    final colorScheme = Theme.of(context).colorScheme;

    // Estilos de texto com base na conclusão da tarefa
    final TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      decoration: tarefa.concluido
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      color: tarefa.concluido ? Colors.grey : Colors.black87,
    );

    return Dismissible(
      key: ValueKey(tarefa.id), // Chave Única usando o ID da Tarefa

      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),

      direction: DismissDirection.endToStart,

      onDismissed: (direction) {
        // 1. Remove da lista e salva no JSON
        removerTarefa(index);
        // 2. Chama setState para reconstruir o ListView (resolve o erro da tela vermelha)
        setState(() {});
        // Feedback visual
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${tarefa.nome} removida!')));
      },

      child: Card(
        // Cor do Card com efeito "zebra"
        color: index.isOdd ? Colors.grey[100] : Colors.white,

        child: InkWell(
          // 1. NAVEGAÇÃO para a tela de detalhes ao tocar
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TarefaDetalheScreen(tarefa: tarefa),
              ),
            );
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone de Conclusão (Check Mark)
                IconButton(
                  icon: Icon(
                    tarefa.concluido
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                  ),
                  iconSize: 30,
                  // Usa a cor de destaque (secondary) do tema
                  color: tarefa.concluido
                      ? colorScheme.secondary
                      : Colors.grey.shade400,
                  onPressed: () {
                    tarefaConcluida(index);
                  },
                ),

                const SizedBox(width: 16), // Espaço extra para "clean look"

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tarefa.nome, style: textStyle),
                      // Data com estilo menor e cinza
                      Text(
                        'Criado em: ${tarefa.data?.day}/${tarefa.data?.month}/${tarefa.data?.year}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Estrutura da Tela ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Tarefas")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Adicionar nova tarefa...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.all(12.0),
              ),
              onSubmitted: adicionarTarefa,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: _buildItem,
            ),
          ),
        ],
      ),
    );
  }
}
