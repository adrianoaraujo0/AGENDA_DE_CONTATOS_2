import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection("Contatos").snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );

          default:
            List<DocumentSnapshot<Map<String, dynamic>>> documentos =
                snapshot.data!.docs;

            return ListView.builder(
              itemCount: documentos.length,
              itemBuilder: (context, index) {
                Map<String, dynamic>? data = documentos[index].data();
                print(data);
                print("Email: ${data!["Email"]}");
                print(data["Telefone"]);
                print(data["Nome"]);
                print(data["Image"]);

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarContato(
                            contato: data[index],
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
                                    data[index], context);
                              },
                              label: "Deseja remover \nesse contato?",
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: buildCard2(data: data, index: index)),
                  ),
                );
              },
            );
        }
      },
    );
  }

  Container buildCard2(
      {required Map<String, dynamic> data, required int index}) {
    String? email = data["Email"];
    String? telefone = data["Telefone"];
    String? nome = data["Nome"];
    String? imagem = data["Image"];

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
