import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/editar/editar_contato_page.dart';
import 'package:rxdart/rxdart.dart';

class Listar extends StatefulWidget {
  Listar({Key? key}) : super(key: key);

  @override
  State<Listar> createState() => _ListarState();
}

class _ListarState extends State<Listar> {
  Controller controller = Controller();

  @override
  void initState() {
    controller.getContato();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
      ),
      body: condicional(),
    );
  }

  Widget condicional() {
    return StreamBuilder<List<ContatoModels>>(
      stream: controller.controller.stream,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
              child: Text("Sem dados!!", style: TextStyle(fontSize: 50)));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print("entrou");
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: Controller.contatos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<bool>(
                          stream: controller.mudarCorFavorito,
                          builder: (context, snapshot) {
                            return ListTile(
                              onTap: () {},
                              leading: Icon(Icons.person_sharp, size: 45),
                              trailing: IconButton(
                                  color: Controller.contatos[index].favorito
                                      ? Colors.yellow
                                      : Colors.grey[400],
                                  icon: Icon(Icons.star),
                                  onPressed: () {
                                    if (Controller.contatos[index].favorito ==
                                        true) {
                                      Controller.contatos[index].favorito =
                                          false;
                                    } else {
                                      Controller.contatos[index].favorito =
                                          true;
                                    }

                                    controller.mudarCorFavorito.sink.add(true);
                                  }),
                              subtitle: Text(
                                  "${Controller.contatos[index].numero}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              title: Text(
                                "${Controller.contatos[index].nome}",
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          );
        } else {
          return Text("data");
        }
      },
    );
  }
}
