import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:rxdart/rxdart.dart';

class ListagemController {
  //Instancia do banco de dados
  ContatoRepository repository = ContatoRepository();
  List<Contato> contatos = [];

  BehaviorSubject<List<Contato>> controller = BehaviorSubject<List<Contato>>();

  Future<void> getContatos() async {
    print("--------------------");
    print(FirebaseFirestore.instance.collection("Contatos"));
    contatos = await repository.getAllContacts();

    controller.sink.add(contatos);
  }

  excluirContato(BuildContext context) async {
    print(FirebaseFirestore.instance.collection("Contatos"));
  }

  //WIDGETS
  SnackBar buildSnackBar(Contato contato) {
    return SnackBar(
      content: Text("Contato excluido com sucesso!"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          //Adicionando o contato excluido.
          repository.saveContact(contato);
          getContatos();
        },
      ),
    );
  }
}
