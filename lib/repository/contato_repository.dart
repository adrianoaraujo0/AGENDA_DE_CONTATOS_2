import 'package:projeto_lista_de_contatos/model/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//COLUNAS
final String contatoTable = "contatoTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imagemColumn = "imagemColumn";
final String favoritoColumn = "favoritoColumn";

class ContatoRepository {
  static final ContatoRepository _instance = ContatoRepository.internal();

  factory ContatoRepository() => _instance;

  ContatoRepository.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contatosnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nomeColumn TEXT, $emailColumn TEXT,"
          "$telefoneColumn TEXT, $imagemColumn TEXT, $favoritoColumn INTEGER)");
    });
  }

  Future<Contato> saveContact(Contato contato) async {
    Database dbContact = await db;
    contato.id = await dbContact.insert(contatoTable, contato.toMap());
    return contato;
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contatoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contato contato) async {
    Database dbContact = await db;
    return await dbContact.update(contatoTable, contato.toMap(),
        where: "$idColumn = ${contato.id}");
  }

  Future<List<Contato>> getAllContacts() async {
 
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contatoTable");
    List<Contato> listContact = [];
    for (Map m in listMap) {
      listContact.add(Contato.fromMap(m));
    }

    return listContact;
  }

  Future<int?> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contatoTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

  void printarContatos() {
    getAllContacts().then(
      (contato) {
        print(contato);
      },
    );
  }
}
