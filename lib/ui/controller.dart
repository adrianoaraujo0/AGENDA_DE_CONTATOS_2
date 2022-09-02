import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/service/conexao.dart';
import 'package:rxdart/rxdart.dart';

class Controller {
  Conexao conexao = Conexao();
  // List<Map> corpoJson = conexao.api();
  static List<ContatoModels> contatos = [];

  BehaviorSubject<List<ContatoModels>> controller =
      BehaviorSubject<List<ContatoModels>>();

  BehaviorSubject<bool> mudarCorFavorito = BehaviorSubject<bool>();
  BehaviorSubject<int> mudarCorBottomNavigation = BehaviorSubject<int>();
  BehaviorSubject<bool> mudarEstadoFavoritosController =
      BehaviorSubject<bool>();

  //RETORNA A LISTA DE JSON DE CONTATOS
  Future<void> getContato() async {
    var corpoJson = await conexao.api();

    for (var contato in corpoJson) {
      contatos.add(ContatoModels.fromModels(contato));
    }
    controller.sink.add(contatos);
  }

  //FILTRA A LISTA DE DE CONTATOS
  List<ContatoModels> filtragemDeContatos() {
    return Controller.contatos
        .where((contatos) => contatos.favorito == true)
        .toList();
  }

  //EXCLUIR O CONTATO DA LISTA DE FAVORITOS
  void mudarEstadoFavoritos(List<ContatoModels> favoritos, int index) {
    int n = Controller.contatos.indexOf(favoritos[index]);
    Controller.contatos[n].favorito = false;
    favoritos[index].favorito = false;

    favoritos.clear();
    favoritos.addAll(filtragemDeContatos());
    mudarEstadoFavoritosController.sink.add(true);
  }

  printarContatos() {
    controller.stream.listen((event) {
      print(event);
    });
  }
}
