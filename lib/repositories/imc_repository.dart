import 'package:imcapp/models/pessoa.dart';

class ImcRepository {
  List<Pessoa> _pessoas = [];

  get pessoas => _pessoas;

  Future<void> addPessoa(Pessoa pessoa) async {
    _pessoas.add(pessoa);
  }

  Future<void> delete (String id) async {
    _pessoas.removeWhere((element) => element.id == id);
  }

}