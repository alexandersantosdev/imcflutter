import 'package:flutter/material.dart';
import 'package:imcapp/models/pessoa.dart';
import 'package:imcapp/repositories/imc_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pessoa> _pessoas = [];
  var imcRepository = ImcRepository();

  TextEditingController nomeController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPessoas();
  }

  getPessoas() async {
    _pessoas = await imcRepository.pessoas;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IMC App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  content: SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(hintText: "Nome: "),
                          controller: nomeController,
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "Peso: "),
                          controller: pesoController,
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Altura: "),
                          controller: alturaController,
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        String nome = nomeController.text;
                        double peso = double.tryParse(pesoController.text) ?? 0;
                        double altura =
                            double.tryParse(alturaController.text) ?? 0;

                        Pessoa p = Pessoa(nome, peso, altura);
                        p.calculaImc();
                        await imcRepository
                            .addPessoa(Pessoa(nome, peso, altura));
                        nomeController.text = "";
                        pesoController.text = "";
                        alturaController.text = "";
                        Navigator.of(context).pop();
                        getPessoas();
                      },
                      child: const Text("Adicionar"),
                    ),
                  ],
                );
              });

          getPessoas();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(children: [
        const Text(
          "Calculadora de IMC",
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: _pessoas.isNotEmpty
              ? ListView.builder(
                  itemCount: _pessoas.length,
                  itemBuilder: (context, index) {
                    Pessoa p = _pessoas[index];
                    Map classificacao = p.classificaPessoa();
                    // ignore: non_constant_identifier_names
                    return Dismissible(
                      key: Key(p.nome),
                      confirmDismiss: (direction) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Deletar pessoa?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                      child: const Text('Deletar'),
                                      onPressed: () async {
                                        await imcRepository.delete(p.id);

                                        Navigator.pop(context);
                                        getPessoas();
                                      })
                                ],
                              );
                            });
                      },
                      child: ListTile(
                        title: Text(
                          p.nome != "" ? p.nome : "Nome não informado",
                        ),
                        subtitle: Text(
                          classificacao["tipo"],
                          style: TextStyle(color: classificacao["cor"]),
                        ),
                      ),
                    );
                  })
              : const Center(child: Text("Nenhuma pessoa cadastrada")),
        )
      ]),
    );
  }
}
