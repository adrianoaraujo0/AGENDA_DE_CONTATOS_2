import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:rxdart/rxdart.dart';

class AdicionarController {
  ContatoRepository repository = ContatoRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imagemController = TextEditingController();
  BehaviorSubject<bool> atualizarFotoPerfil = BehaviorSubject<bool>();

  Future<void> salvarContato(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState?.validate() == false) {
      formKey.currentState?.validate();
    } else {
      ///SQLFLITE
      repository.saveContact(
        Contato(
          nome: nomeController.text,
          telefone: telefoneController.text,
          email: emailController.text,
          imagem: imagemController.text,
        ),
      );

      await adicionarContatoFirebase();

      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      imagemController.clear();

      atualizarFotoPerfil.sink.add(true);

      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(),
      );
      //FIREBASE

    }
  }

  atualizarFotoAposAdicionarOuRemoverFoto(String path) {
    imagemController.text = path;
    atualizarFotoPerfil.sink.add(true);
  }

  Future<void> adicionarContatoFirebase() async {
    if (imagemController.text != null) {
      //uploadtask: Uma classe que indica uma tarefa de upload em andamento.
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imagemController.text));

      //Um [TaskSnapshot] é retornado como resultado ou processo em andamento de um [Task].
      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection("Contatos").add(
      {
        "Nome": nomeController.text,
        "Telefone": telefoneController.text,
        "Email": emailController.text,
        "Image": imagemController.text
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
