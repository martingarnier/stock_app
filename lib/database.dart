import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:testapp/models/inventaire.dart';
import 'package:testapp/models/produit.dart';

import 'fonctions.dart';



class DBProvider{

  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;
  bool estRempli = false;

  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDB();

    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'inventaire_database.db'),
      onOpen: (db) async {},
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE info(id_inventaire INTEGER, id_produit INTEGER)");
        await db.execute("CREATE TABLE inventaire(id_inventaire INTEGER PRIMARY KEY, nom_inventaire TEXT)");
        await db.execute("CREATE TABLE produit(id_produit INTEGER PRIMARY KEY, id_inventaire INTEGER, nom_produit TEXT, quantite INTEGER)");

        await db.insert('info', {
          'id_inventaire': 0,
          'id_produit': 0
        });
      },
    );
  }

  void remplirListe(BuildContext context) async {
    if(!estRempli){
      (await inventaires()).forEach((inventaire) async {
        Provider.of<ModelListInventaire>(context, listen: false).ajouter(inventaire);
        (await produits()).forEach((produit) {
          if(produit.idInventaire == inventaire.idInventaire) inventaire.ajouter(produit);
        });
      });

      estRempli = true;
    }
  }

  Future<int> getNextIdInventaire() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('info');

    await db.update(
        'info',
        {
          'id_inventaire': maps[0]['id_inventaire']+1,
          'id_produit': maps[0]['id_produit']
        }
    );

    return maps[0]['id_inventaire'];
  }


  Future<int> getNextIdProduit() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('info');

    await db.update(
        'info',
        {
          'id_inventaire': maps[0]['id_inventaire'],
          'id_produit': maps[0]['id_produit']+1
        }
    );

    return maps[0]['id_produit'];
  }




  Future<List<Inventaire>> inventaires() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('inventaire');

    return List.generate(maps.length, (i) {
      return Inventaire(maps[i]['id_inventaire'], maps[i]['nom_inventaire']);
    });
  }


  Future<void> insererInventaire(Inventaire inventaire) async{
    final Database db = await database;

    await db.insert(
      'inventaire',
      inventaire.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> updateInventaire(Inventaire inventaire) async{
    final db = await database;

    await db.update(
        'inventaire',
        inventaire.toMap(),
        where: "id_inventaire = ?",
        whereArgs: [inventaire.idInventaire]
    );
  }


  Future<void> supprimerInventaire(int id) async{
    final db = await database;

    await db.delete(
        'inventaire',
        where: "id_inventaire = ?",
        whereArgs: [id]
    );
  }




  Future<List<Produit>> produits() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('produit');

    return List.generate(maps.length, (i) {
      return Produit(maps[i]['id_produit'], maps[i]['id_inventaire'], maps[i]['nom_produit'], maps[i]['quantite']);
    });
  }


  Future<void> insererProduit(Produit produit) async{
    final Database db = await database;

    await db.insert(
      'produit',
      produit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> updateProduit(Produit produit) async{
    final db = await database;

    await db.update(
        'produit',
        produit.toMap(),
        where: "id_produit = ?",
        whereArgs: [produit.idProduit]
    );
  }


  Future<void> supprimerProduit(int id) async{
    final db = await database;

    await db.delete(
        'produit',
        where: "id_produit = ?",
        whereArgs: [id]
    );
  }
}