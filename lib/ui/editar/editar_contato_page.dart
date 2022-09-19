import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:projeto_lista_de_contatos/ui/adicionar/adicionar_controller.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/editar/editar_controller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EditarContato extends StatefulWidget {
  EditarContato({required this.contato, Key? key}) : super(key: key);

  Contato contato;
  @override
  State<EditarContato> createState() => _EditarContatoState();
}

class _EditarContatoState extends State<EditarContato> {
  EditarController editarController = EditarController();
  var maskPhone = MaskTextInputFormatter(mask: "(##) #####-####");

  @override
  void initState() {
    editarController.nomeController.text = widget.contato.nome!;
    editarController.telefoneController.text = widget.contato.telefone!;
    editarController.emailController.text = widget.contato.email!;
    editarController.imagem = widget.contato.imagem!;
    editarController.favorito = widget.contato.favorito;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: editarController.mudarCorFavorito.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Editar contatos"),
              actions: [
                IconButton(
                  onPressed: () {
                    launchUrlString(
                        'tel:${editarController.telefoneController.text}');
                  },
                  icon: Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (editarController.favorito == true) {
                      editarController.favorito = false;

                      editarController.mudarCorFavorito.sink.add(true);
                    } else {
                      editarController.favorito = true;
                      editarController.mudarCorFavorito.sink.add(false);
                    }
                  },
                  icon: Icon(
                    Icons.star,
                    color: editarController.favorito == true
                        ? Colors.yellow[400]
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  StreamBuilder<bool>(
                      stream: editarController.atualizarFotoContato.stream,
                      builder: (context, snapshot) {
                        return GestureDetector(
                          child: Container(
                            width: 140,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: editarController.imagem != null &&
                                        editarController.imagem!.isNotEmpty
                                    ? FileImage(File(editarController.imagem!))
                                    : AssetImage("images/person.png")
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          onTap: () {
                            ImagePicker.platform
                                .pickImage(source: ImageSource.camera)
                                .then(
                              (file) {
                                if (file == null) {
                                  return;
                                } else {
                                  editarController.imagem = file.path;

                                  editarController.atualizarFotoContato.sink
                                      .add(true);
                                }
                              },
                            );
                          },
                        );
                      }),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Expanded(
                          child: buildTextField(
                              teclado: TextInputType.name,
                              controller: editarController.nomeController,
                              hintText: "ex: Jose Medeiros",
                              labelText: "Nome do contato")),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                            inputFormatters: [maskPhone],
                            controller: editarController.telefoneController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "ex: (88) 9 6573 2341",
                                labelText: "Telefone do contato"),
                            keyboardType: TextInputType.phone),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10),
                      Expanded(
                          child: buildTextField(
                              teclado: TextInputType.emailAddress,
                              controller: editarController.emailController,
                              hintText: "ex: jose@yahoo.com.br",
                              labelText: "Email do contato")),
                    ],
                  ),
                ],
              ),
            )),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: (() {
                editarController.editarContato(widget.contato, context);
                Navigator.pop(context);
              }),
            ),
          );
        });
  }

  TextField buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required String labelText,
      required TextInputType teclado}) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            labelText: labelText),
        keyboardType: teclado);
  }
}
