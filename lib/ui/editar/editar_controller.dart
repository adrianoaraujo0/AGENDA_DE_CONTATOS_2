import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_controller.dart';
import 'package:rxdart/rxdart.dart';

class EditarController {
  ContatoRepository repository = ContatoRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool? favorito;
  String? imagem;

  ListagemController listagemController = ListagemController();
  BehaviorSubject<bool> mudarCorFavorito = BehaviorSubject<bool>();
  BehaviorSubject<bool> atualizarFotoContato = BehaviorSubject<bool>();

  Future<void> editarContato(Contato contato, BuildContext context) async {
    contato.nome = nomeController.text;
    contato.telefone = telefoneController.text;
    contato.email = emailController.text;
    contato.favorito = favorito!;
    contato.imagem = imagem;

    repository.updateContact(contato);

    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(),
    );
  }

  Future<void> atualizarFavoritos() async {
    if (favorito == true) {
      favorito = false;
      mudarCorFavorito.sink.add(true);
    } else {
      favorito = true;
      mudarCorFavorito.sink.add(false);
    }
  }

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Text("Contato editado com sucesso!"),
      backgroundColor: Colors.green,
    );
  }
}
