import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:rxdart/rxdart.dart';

class AdicionarController {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imagemController = TextEditingController();
  BehaviorSubject<bool> atualizarFotoPerfil = BehaviorSubject<bool>();

  salvarContato(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState?.validate() == false) {
      formKey.currentState?.validate();
    } else {
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
    //validacao da imagem de perfil
    if (imagemController.text != null && imagemController.text.isNotEmpty) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imagemController.text));

      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
    }

    if (imagemController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("Contatos").add(
        {
          "Nome": nomeController.text,
          "Telefone": telefoneController.text,
          "Email": emailController.text,
          "Image": imagemController.text,
          "Favoritos": false
        },
      );
    } else {
      FirebaseFirestore.instance.collection("Contatos").add(
        {
          "Nome": nomeController.text,
          "Telefone": telefoneController.text,
          "Email": emailController.text,
          "Image": "",
          "Favoritos": false
        },
      );
    }
  }

  SnackBar buildSnackBar() {
    return const SnackBar(
      content: Text("Contato salvo com sucesso!"),
      backgroundColor: Colors.green,
    );
  }
}
