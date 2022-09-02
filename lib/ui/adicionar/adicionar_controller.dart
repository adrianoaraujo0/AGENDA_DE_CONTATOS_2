import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';

class AdicionarController {
  ContatoRepository repository = ContatoRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imagemController = TextEditingController();

  Future<void> salvarContato(BuildContext context) async {
    repository.saveContact(Contato(
      nome: nomeController.text,
      telefone: telefoneController.text,
      email: emailController.text,
      imagem: imagemController.text,
    ));

    nomeController.clear();
    telefoneController.clear();
    emailController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(),
    );
  }

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Text("Contato salvo com sucesso!"),
      backgroundColor: Colors.green,
    );
  }
}
