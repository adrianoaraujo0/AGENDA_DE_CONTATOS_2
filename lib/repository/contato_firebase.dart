import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ContatoFirebase {
  Future<void> inserirDados() async {
    FirebaseFirestore.instance
        .collection("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        .doc("NkJGKH9CdQTzyvyIMS4D")
        .collection("arquivos")
        .doc()
        .set({
      "image": "foto_perfil.png",
    });
  }
}
