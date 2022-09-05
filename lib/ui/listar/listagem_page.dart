import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:projeto_lista_de_contatos/ui/adicionar/adicionar_page.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/editar/editar_contato_page.dart';
import 'package:projeto_lista_de_contatos/ui/editar/editar_controller.dart';
import 'package:projeto_lista_de_contatos/ui/favoritos/favoritos_controller.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_controller.dart';
import 'package:rxdart/rxdart.dart';

class Listagem extends StatefulWidget {
  Listagem({Key? key}) : super(key: key);

  @override
  State<Listagem> createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  ListagemController listagemController = ListagemController();
  FavoritosController favoritosController = FavoritosController();

  @override
  void initState() {
    listagemController.getContatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildStreamBuilder(),
    );
  }

  Widget buildStreamBuilder() {
    return StreamBuilder<List<Contato>>(
      stream: listagemController.controller.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Text("Dados Nulos");
        }
        if (snapshot.data!.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () async {
                    print("Contato = ${snapshot.data![index]}");
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarContato(
                          contato: snapshot.data![index],
                        ),
                      ),
                    );

                    listagemController.getContatos();
                    favoritosController.getFavoritos();
                  },
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            listagemController.excluirContato(
                                snapshot.data![index], context);
                          },
                          label: "Deseja remover \nesse contato?",
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: buildCard(snapshot: snapshot, index: index),
                  ),
                ),
              );
            },
          );
        } else {
          return Text("data");
        }
      },
    );
  }

  Container buildCard({required AsyncSnapshot snapshot, required int index}) {
    String? nome = snapshot.data[index].nome;
    String? telefone = snapshot.data[index].telefone;
    String? email = snapshot.data[index].email;
    String? imagem = snapshot.data[index].imagem;

    return Container(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imagem != null && imagem.isNotEmpty
                            ? FileImage(File(imagem))
                            : AssetImage("images/person.png") as ImageProvider,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$nome",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "$telefone",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
