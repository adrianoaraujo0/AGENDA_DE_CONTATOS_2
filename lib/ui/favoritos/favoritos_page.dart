import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<ContatoModels> favoritos = [];
  Controller controller = Controller();

  @override
  void initState() {
    favoritos = controller.filtragemDeContatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(favoritos.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: StreamBuilder(
        stream: controller.mudarEstadoFavoritosController.stream,
        builder: (context, snapshot) {
          return favoritos.isEmpty
              ? Center(child: Text("LISTA DE FAVORITOS VAZIA"))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // lógica de remover favorito.
                          // int n = Controller.contatos.indexOf(favoritos[index]);
                          // Controller.contatos[n].favorito = false;
                          // favoritos[index].favorito = false;
                          Slidable(
                            direction: Axis.horizontal,
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                    onPressed: (context) {
                                      List<ContatoModels> desfazer =
                                          controller.filtragemDeContatos();
                                      String nome = favoritos[index].nome;

                                      controller.mudarEstadoFavoritos(
                                          favoritos, index);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              buidSnackBar(desfazer, nome));
                                    },
                                    backgroundColor: Colors.red,
                                    label: "Deseja remover dos\nfavoritos?")
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(Icons.person, size: 50),
                              title: Text("${favoritos[index].nome}"),
                              subtitle: Text("${favoritos[index].numero}"),
                              trailing: Icon(
                                Icons.phone,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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

          controller.mudarEstadoFavoritosController.sink.add(true);
        },
      ),
    );
  }
}
