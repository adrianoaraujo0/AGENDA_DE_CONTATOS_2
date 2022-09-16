import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:projeto_lista_de_contatos/repository/contato_firebase.dart';
import 'package:projeto_lista_de_contatos/repository/contato_repository.dart';
import 'package:projeto_lista_de_contatos/ui/controller.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_controller.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_page.dart';
import 'package:projeto_lista_de_contatos/ui/listar/listagem_page_setstate.dart';
import 'package:projeto_lista_de_contatos/ui/adicionar/adicionar_page.dart';
import 'package:projeto_lista_de_contatos/ui/favoritos/favoritos_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContatoRepository().db;
  await Firebase.initializeApp();

  ContatoFirebase c = ContatoFirebase();
  c.inserirDados();

  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Controller controller = Controller();
  PageController pageController = PageController();
  ListagemController listagemController = ListagemController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            Listagem(),
            Favoritos(),
            Adicionar(),
          ],
          onPageChanged: (value) {
            controller.mudarCorBottomNavigation.sink.add(value);
          },
        ),
        bottomNavigationBar: buildBottomNavigation(),
      ),
    );
  }

  Widget buildBottomNavigation() {
    return StreamBuilder<int>(
        initialData: 0,
        stream: controller.mudarCorBottomNavigation.stream,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            backgroundColor: Colors.grey[800],
            onTap: (value) {
              pageController.animateToPage(value,
                  duration: Duration(microseconds: 400), curve: Curves.ease);
            },
            selectedItemColor: Colors.blue,
            currentIndex: snapshot.data!,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 35),
                label: "Contatos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star, size: 35),
                label: "Favoritos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add, size: 35),
                label: "Adicionar",
              ),
            ],
          );
        });
  }
}
