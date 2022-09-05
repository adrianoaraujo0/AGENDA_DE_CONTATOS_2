import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/favoritos/favoritos_controller.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<ContatoModels> favoritos = [];
  FavoritosController favoritosController = FavoritosController();

  @override
  void initState() {
    favoritosController.getFavoritos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Contato>>(
        stream: favoritosController.controller.stream,
        builder: (context, snapshot) {
          if (snapshot == null && snapshot.data!.isEmpty) {
            return Center(
              child: Text("Dados nulos"),
            );
          } else if (snapshot.hasData) {
            print("Entrou");
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildCard(snapshot: snapshot, index: index),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text("data");
          }
        },
      ),
    );
  }

  SnackBar buidSnackBar(List<ContatoModels> listaAntesDaExclusao, String nome) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Text("${nome} não é mais um contato favorito!!"),
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          print(listaAntesDaExclusao);
          favoritos = listaAntesDaExclusao;

          // controller.mudarEstadoFavoritosController.sink.add(true);
        },
      ),
    );
  }

  InkWell buildCard({required AsyncSnapshot snapshot, required int index}) {
    String? nome = snapshot.data[index].nome;
    String? telefone = snapshot.data[index].telefone;
    String? imagem = snapshot.data[index].imagem;

    return InkWell(
      child: Container(
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
                              : AssetImage("images/person.png")
                                  as ImageProvider,
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
              IconButton(
                  onPressed: () {
                    launchUrlString('tel:${telefone}');
                  },
                  icon: Icon(Icons.phone, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
