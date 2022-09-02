class Contato {
  int? id;
  String? nome;
  String? telefone;
  String? imagem;
  String? email;
  bool favorito;

  //CONSTRUTOR
  Contato({
    this.id,
    this.nome,
    this.telefone,
    this.imagem,
    this.email,
    this.favorito = false,
  });

  factory Contato.fromMap(Map map) {
    return Contato(
      id: map['idColumn'],
      nome: map['nomeColumn'],
      telefone: map['telefoneColumn'],
      imagem: map['imagemColumn'],
      email: map['emailColumn'],
      favorito: map['favoritoColumn'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      if (id != null) 'idColumn': id,
      'nomeColumn': nome,
      'telefoneColumn': telefone,
      'imagemColumn': imagem,
      'emailColumn': email,
      'favoritoColumn': favorito == true ? 1 : 0,
    };
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "nome: $nome, telefone: $telefone, imagem: $imagem, email: $email, favorito: $favorito";
  }
}
