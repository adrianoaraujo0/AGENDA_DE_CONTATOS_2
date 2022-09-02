import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/model/contato_model.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:projeto_lista_de_contatos/ui/adicionar/adicionar_controller.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/editar/editar_controller.dart';
import 'package:rxdart/rxdart.dart';

class EditarContato extends StatefulWidget {
  EditarContato({required this.contato, Key? key}) : super(key: key);

  Contato contato;
  @override
  State<EditarContato> createState() => _EditarContatoState();
}

class _EditarContatoState extends State<EditarContato> {
  EditarController editarController = EditarController();

  @override
  void initState() {
    editarController.nomeController.text = widget.contato.nome!;
    editarController.telefoneController.text = widget.contato.telefone!;
    editarController.emailController.text = widget.contato.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar contatos")),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    child: buildTextField(
                        teclado: TextInputType.phone,
                        controller: editarController.telefoneController,
                        hintText: "ex: (85) 98995-5643",
                        labelText: "Telefone do contato")),
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
        }),
      ),
    );
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
