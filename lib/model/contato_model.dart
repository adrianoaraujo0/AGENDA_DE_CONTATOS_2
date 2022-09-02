class ContatoModels {
  String nome;
  String numero;
  String? imagem;
  String? email;
  bool favorito;

  ContatoModels({
    required this.nome,
    required this.numero,
    this.imagem,
    this.email,
    this.favorito = false,
  });

  factory ContatoModels.fromModels(Map map) {
    return ContatoModels(nome: map["name"], numero: map["address"]["zipcode"]);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "name: $nome, numero: $numero, imagem: $imagem, email: $email, favorito: $favorito";
  }
}
