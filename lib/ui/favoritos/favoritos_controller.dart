import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavoritosController {
  ContatoRepository repository = ContatoRepository();
  BehaviorSubject<List<Contato>> controller = BehaviorSubject<List<Contato>>();
  List<Contato> contatos = [];
  List<Contato> favoritos = [];

  Future<void> getFavoritos() async {
    contatos = await repository.getAllContacts();

    for (Contato contato in contatos) {
      if (contato.favorito == true) {
        favoritos.add(contato);
      }
      controller.sink.add(favoritos);
    }
  }
}
