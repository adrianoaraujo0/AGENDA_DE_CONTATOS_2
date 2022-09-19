import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:rxdart/rxdart.dart';

class Adicionar extends StatelessWidget {
  Adicionar({Key? key}) : super(key: key);

  AdicionarController adicionarController = AdicionarController();
  String? imagemPefil;
  final formKey = GlobalKey<FormState>();
  var maskPhone = MaskTextInputFormatter(mask: "(##) #####-####");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar contatos")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<bool>(
                  stream: adicionarController.atualizarFotoPerfil.stream,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      child: Container(
                        width: 140,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: adicionarController
                                    .imagemController.text.isNotEmpty
                                ? FileImage(File(
                                    adicionarController.imagemController.text))
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
                              adicionarController
                                  .atualizarFotoAposAdicionarOuRemoverFoto(
                                      file.path);

                              // adicionarController.atualizarFotoPerfil.sink
                              //     .add(true);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Expanded(
                        child: buildTextField(
                            validador: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Nome obrigatório";
                              }
                            },
                            teclado: TextInputType.name,
                            controller: adicionarController.nomeController,
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
                      child: TextFormField(
                        inputFormatters: [maskPhone],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Telefone obrigatório";
                          }
                        },
                        keyboardType: TextInputType.phone,
                        controller: adicionarController.telefoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "ex: (85) 98995-5643",
                          labelText: "Telefone do contato",
                        ),
                      ),
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
                      child: TextFormField(
                        controller: adicionarController.emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "ex: jose@yahoo.com.br",
                            labelText: "Email do contato"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => adicionarController.salvarContato(context, formKey),
      ),
    );
  }

  TextFormField buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required TextInputType teclado,
    required validador,
  }) {
    return TextFormField(
        validator: validador,
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            labelText: labelText),
        keyboardType: teclado);
  }
}
