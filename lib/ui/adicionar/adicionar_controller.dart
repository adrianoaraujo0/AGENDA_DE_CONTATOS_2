import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:rxdart/rxdart.dart';

class AdicionarController {
  ContatoRepository repository = ContatoRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imagemController = TextEditingController();
  BehaviorSubject<bool> atualizarFoto = BehaviorSubject<bool>();

  Future<void> salvarContato(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState?.validate() == false) {
      formKey.currentState?.validate();
    } else {
      ///SQLFLITE
      repository.saveContact(Contato(
          nome: nomeController.text,
          telefone: telefoneController.text,
          email: emailController.text,
          imagem: imagemController.text));
      adicionarContatoFirebase();
      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      imagemController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(),
      );
      //FIREBASE

    }
  }

  void adicionarContatoFirebase() {
    FirebaseFirestore.instance.collection("Contatos").add(
      {
        "Nome": nomeController.text,
        "Telefone": telefoneController.text,
        "Email": emailController.text
      },
    );
  }

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Text("Contato salvo com sucesso!"),
      backgroundColor: Colors.green,
    );
  }
}
