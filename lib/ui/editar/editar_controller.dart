import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';

class EditarController {
  ContatoRepository repository = ContatoRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> editarContato(Contato contato, BuildContext context) async {
    contato.nome = nomeController.text;
    contato.telefone = telefoneController.text;
    contato.email = emailController.text;

    repository.updateContact(contato);

    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(),
    );
  }

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Text("Contato editado com sucesso!"),
      backgroundColor: Colors.green,
    );
  }
}
